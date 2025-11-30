import 'package:fruit_app/data/local_storage/local_storage.dart';
import 'package:fruit_app/data/models/recipe_model.dart';
import 'package:fruit_app/domain/repositories/recipe_repository.dart';
import 'dart:convert';

class RecipeRepositoryImpl implements RecipeRepository {
  final LocalStorage localStorage;

  RecipeRepositoryImpl({required this.localStorage});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    final recipesJson = localStorage.getRecipes();
    return recipesJson.map((jsonString) {
      return RecipeModel.fromJson(json.decode(jsonString));
    }).toList();
  }

  @override
  Future<void> saveRecipe(RecipeModel recipe) async {
    await localStorage.saveRecipe(json.encode(recipe.toJson()));
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    await localStorage.deleteRecipe(recipeId);
  }

  @override
  List<String> getFavorites() {
    return localStorage.getFavorites();
  }

  @override
  Future<void> addToFavorites(String fruitId) async {
    await localStorage.addToFavorites(fruitId);
  }

  @override
  Future<void> removeFromFavorites(String fruitId) async {
    await localStorage.removeFromFavorites(fruitId);
  }

  @override
  bool isFavorite(String fruitId) {
    return localStorage.isFavorite(fruitId);
  }
}