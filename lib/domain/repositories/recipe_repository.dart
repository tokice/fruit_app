import '../../data/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getRecipes();
  Future<void> saveRecipe(RecipeModel recipe);
  Future<void> deleteRecipe(String recipeId);
  List<String> getFavorites();
  Future<void> addToFavorites(String fruitId);
  Future<void> removeFromFavorites(String fruitId);
  bool isFavorite(String fruitId);
}