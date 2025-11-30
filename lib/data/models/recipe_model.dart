import 'package:equatable/equatable.dart';
import 'fruit_model.dart';

class RecipeModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<FruitModel> fruits;
  final DateTime createdAt;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fruits,
    required this.createdAt,
  });

  Nutritions get totalNutritions {
    return Nutritions(
      calories: fruits.fold(0.0, (sum, fruit) => sum + fruit.nutritions.calories),
      fat: fruits.fold(0.0, (sum, fruit) => sum + fruit.nutritions.fat),
      sugar: fruits.fold(0.0, (sum, fruit) => sum + fruit.nutritions.sugar),
      carbohydrates: fruits.fold(0.0, (sum, fruit) => sum + fruit.nutritions.carbohydrates),
      protein: fruits.fold(0.0, (sum, fruit) => sum + fruit.nutritions.protein),
    );
  }

  String get fruitsString => fruits.map((fruit) => fruit.name).join(', ');

  RecipeModel copyWith({
    String? name,
    String? description,
    List<FruitModel>? fruits,
  }) {
    return RecipeModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      fruits: fruits ?? this.fruits,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fruits': fruits.map((fruit) => fruit.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fruits: (json['fruits'] as List<dynamic>?)
          ?.map((fruitJson) => FruitModel.fromJson(fruitJson))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [id, name, description, fruits, createdAt];
}