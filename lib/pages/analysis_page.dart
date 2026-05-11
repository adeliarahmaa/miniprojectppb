import 'package:flutter/material.dart';
import '../services/food_service.dart';

class AnalysisPage extends StatelessWidget {
  AnalysisPage({super.key});

  final FoodService service = FoodService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Analysis")),

      body: StreamBuilder(
        stream: service.getFoods(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final foods = snapshot.data!;

          int total = 0;
          Map<String, int> mood = {};

          for (var f in foods) {
            total += f.calories;
            mood[f.mood] = (mood[f.mood] ?? 0) + 1;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_fire_department),
                    title: const Text("Total Calories"),
                    subtitle: Text("$total kcal"),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.fastfood),
                    title: const Text("Total Food"),
                    subtitle: Text("${foods.length} items"),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Mood Analysis",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Expanded(
                  child: ListView(
                    children: mood.entries.map((e) {
                      return Card(
                        child: ListTile(
                          title: Text(e.key),
                          trailing: Text("${e.value}x"),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
