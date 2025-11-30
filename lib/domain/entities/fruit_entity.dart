import 'package:equatable/equatable.dart';

class FruitEntity extends Equatable {
  final String name;
  final int id;
  final String family;
  final String order;
  final String genus;
  final NutritionsEntity nutritions;

  const FruitEntity({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  @override
  List<Object?> get props => [id, name, family, order, genus, nutritions];
}

class NutritionsEntity extends Equatable {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  const NutritionsEntity({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  @override
  List<Object?> get props => [calories, fat, sugar, carbohydrates, protein];
}