import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<LocalStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return LocalStorage();
  }

  // Favorites
  List<String> getFavorites() {
    return _prefs.getStringList('favorites') ?? [];
  }

  Future<void> addToFavorites(String fruitId) async {
    final favorites = getFavorites();
    if (!favorites.contains(fruitId)) {
      favorites.add(fruitId);
      await _prefs.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFromFavorites(String fruitId) async {
    final favorites = getFavorites();
    favorites.remove(fruitId);
    await _prefs.setStringList('favorites', favorites);
  }

  bool isFavorite(String fruitId) {
    return getFavorites().contains(fruitId);
  }

  // Recipes
  List<String> getRecipes() {
    return _prefs.getStringList('recipes') ?? [];
  }

  Future<void> saveRecipe(String recipeJson) async {
    final recipes = getRecipes();
    recipes.add(recipeJson);
    await _prefs.setStringList('recipes', recipes);
  }

  Future<void> updateRecipes(List<String> recipesJson) async {
    await _prefs.setStringList('recipes', recipesJson);
  }

  Future<void> deleteRecipe(String recipeId) async {
    final recipes = getRecipes();
    recipes.removeWhere((recipeJson) {
      final recipeMap = json.decode(recipeJson);
      return recipeMap['id'] == recipeId;
    });
    await _prefs.setStringList('recipes', recipes);
  }
}