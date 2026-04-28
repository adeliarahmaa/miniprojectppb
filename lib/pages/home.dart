import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  final String mode;

  const HomePage({super.key, required this.mode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FoodService service = FoodService();
  final StorageService storage = StorageService();

  File? imageFile;

  int totalCalories = 0;

  int get dailyLimit => widget.mode == "diet" ? 1500 : 2000;

  // =========================
  // CAMERA
  // =========================
  Future<void> pickCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // =========================
  // CREATE (ADD)
  // =========================
  void showAddDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final moodController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Tambah Food"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: calController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Kalori"),
                ),
                TextField(
                  controller: moodController,
                  decoration: const InputDecoration(labelText: "Mood"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    await pickCamera();
                    setStateDialog(() {});
                  },
                  child: const Text("Ambil Foto"),
                ),

                if (imageFile != null) Image.file(imageFile!, height: 100),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String imageUrl = "";

                  if (imageFile != null) {
                    imageUrl = await storage.uploadImage(imageFile!);
                  }

                  int cal = int.tryParse(calController.text) ?? 0;
                  totalCalories += cal;

                  await service.addFood(
                    FoodModel(
                      name: nameController.text,
                      calories: cal,
                      mood: moodController.text,
                      imageUrl: imageUrl,
                    ),
                  );

                  // NOTIF
                  if (totalCalories > dailyLimit) {
                    await NotificationService.showNotification(
                      id: 1,
                      title: "Over Limit",
                      body: "Kalori: $totalCalories / $dailyLimit",
                    );
                  } else if (totalCalories < dailyLimit) {
                    await NotificationService.showNotification(
                      id: 2,
                      title: "Belum Target",
                      body: "Masih $totalCalories dari $dailyLimit",
                    );
                  } else {
                    await NotificationService.showNotification(
                      id: 3,
                      title: "Target Pas",
                      body: "Kamu tepat $dailyLimit kcal",
                    );
                  }

                  if (!mounted) return;
                  Navigator.pop(context);

                  setState(() {
                    imageFile = null;
                  });
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================
  // UPDATE (EDIT)
  // =========================
  void showEditDialog(FoodModel food) {
    final nameController = TextEditingController(text: food.name);
    final calController = TextEditingController(text: food.calories.toString());
    final moodController = TextEditingController(text: food.mood);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Food"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: calController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kalori"),
            ),
            TextField(
              controller: moodController,
              decoration: const InputDecoration(labelText: "Mood"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await service.updateFood(
                food.id!,
                FoodModel(
                  name: nameController.text,
                  calories: int.tryParse(calController.text) ?? 0,
                  mood: moodController.text,
                  imageUrl: food.imageUrl,
                ),
              );

              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MoodBite (${widget.mode})"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Mode: ${widget.mode.toUpperCase()} | Target: $dailyLimit | Total: $totalCalories",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: service.getFoods(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final foods = snapshot.data!;

                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];

                    return Card(
                      child: ListTile(
                        leading: food.imageUrl.isNotEmpty
                            ? Image.network(food.imageUrl, width: 50)
                            : const Icon(Icons.fastfood),

                        title: Text(food.name),
                        subtitle: Text("${food.calories} kcal • ${food.mood}"),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showEditDialog(food),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                service.deleteFood(food.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
