import 'package:equatable/equatable.dart';
import 'fruit_entity.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<FruitEntity> fruits;
  final DateTime createdAt;

  const RecipeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.fruits,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, fruits, createdAt];
}