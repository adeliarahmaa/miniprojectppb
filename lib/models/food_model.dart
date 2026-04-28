class FoodModel {
  String? id;
  String name;
  int calories;
  String mood;
  String imageUrl;

  FoodModel({
    this.id,
    required this.name,
    required this.calories,
    required this.mood,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'mood': mood,
      'imageUrl': imageUrl,
    };
  }

  factory FoodModel.fromMap(String id, Map<String, dynamic> map) {
    return FoodModel(
      id: id,
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      mood: map['mood'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
