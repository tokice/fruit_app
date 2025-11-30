import '../../data/models/fruit_model.dart';

abstract class FruitRepository {
  Future<List<FruitModel>> getAllFruits();
}