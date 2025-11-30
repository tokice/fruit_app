import 'package:equatable/equatable.dart';

class FruitModel extends Equatable {
  final String name;
  final int id;
  final String family;
  final String order;
  final String genus;
  final Nutritions nutritions;

  const FruitModel({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory FruitModel.fromJson(Map<String, dynamic> json) {
    return FruitModel(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      family: json['family'] ?? '',
      order: json['order'] ?? '',
      genus: json['genus'] ?? '',
      nutritions: Nutritions.fromJson(json['nutritions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'family': family,
      'order': order,
      'genus': genus,
      'nutritions': nutritions.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, name, family, order, genus, nutritions];
}

class Nutritions extends Equatable {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  const Nutritions({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory Nutritions.fromJson(Map<String, dynamic> json) {
    return Nutritions(
      calories: (json['calories'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      sugar: (json['sugar'] ?? 0.0).toDouble(),
      carbohydrates: (json['carbohydrates'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fat': fat,
      'sugar': sugar,
      'carbohydrates': carbohydrates,
      'protein': protein,
    };
  }

  @override
  List<Object?> get props => [calories, fat, sugar, carbohydrates, protein];
}