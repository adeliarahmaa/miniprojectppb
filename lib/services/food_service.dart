import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodService {
  final CollectionReference foods = FirebaseFirestore.instance.collection(
    'foods',
  );

  // CREATE
  Future<void> addFood(FoodModel food) async {
    await foods.add(food.toMap());
  }

  // READ
  Stream<List<FoodModel>> getFoods() {
    return foods.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  //UPDATE
  Future<void> updateFood(String id, FoodModel food) async {
    await foods.doc(id).update(food.toMap());
  }

  // DELETE
  Future<void> deleteFood(String id) async {
    await foods.doc(id).delete();
  }
}
