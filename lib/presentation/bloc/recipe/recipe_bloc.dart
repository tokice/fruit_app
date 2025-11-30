import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_app/data/models/fruit_model.dart';
import 'package:fruit_app/data/models/recipe_model.dart';
import 'package:fruit_app/data/repositories/fruit_repository_impl.dart';
import 'package:fruit_app/data/repositories/recipe_repository_impl.dart';

// Events
abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class LoadFavorites extends RecipeEvent {}

class LoadAllFruits extends RecipeEvent {}

class CreateRecipe extends RecipeEvent {
  final String name;
  final String description;
  final List<FruitModel> fruits;

  const CreateRecipe({
    required this.name,
    required this.description,
    required this.fruits,
  });

  @override
  List<Object> get props => [name, description, fruits];
}

class DeleteRecipe extends RecipeEvent {
  final String recipeId;

  const DeleteRecipe({required this.recipeId});

  @override
  List<Object> get props => [recipeId];
}

class ToggleFavoriteRecipe extends RecipeEvent {
  final int fruitId;

  const ToggleFavoriteRecipe({required this.fruitId});

  @override
  List<Object> get props => [fruitId];
}

// States
abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<RecipeModel> recipes;

  const RecipesLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class FavoritesLoaded extends RecipeState {
  final List<FruitModel> fruits;

  const FavoritesLoaded({required this.fruits});

  @override
  List<Object> get props => [fruits];
}

class AllFruitsLoaded extends RecipeState {
  final List<FruitModel> fruits;

  const AllFruitsLoaded({required this.fruits});

  @override
  List<Object> get props => [fruits];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError({required this.message});

  @override
  List<Object> get props => [message];
}

class RecipeCreated extends RecipeState {}

// BLoC
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepositoryImpl recipeRepository;
  final FruitRepositoryImpl fruitRepository;

  List<FruitModel> _allFruits = [];
  List<FruitModel> _favoriteFruits = [];

  RecipeBloc({
    required this.recipeRepository,
    required this.fruitRepository,
  }) : super(RecipeInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<LoadFavorites>(_onLoadFavorites);
    on<CreateRecipe>(_onCreateRecipe);
    on<DeleteRecipe>(_onDeleteRecipe);
    on<ToggleFavoriteRecipe>(_onToggleFavorite);
    on<LoadAllFruits>(_onLoadAllFruits);
  }

  bool isFavorite(String fruitId) {
    return recipeRepository.isFavorite(fruitId);
  }

  void _onLoadRecipes(LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      final recipes = await recipeRepository.getRecipes();
      emit(RecipesLoaded(recipes: recipes));
    } catch (e) {
      emit(RecipeError(message: 'Failed to load recipes: $e'));
    }
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      _allFruits = await fruitRepository.getAllFruits();
      final favoriteIds = recipeRepository.getFavorites();
      _favoriteFruits = _allFruits.where((fruit) {
        return favoriteIds.contains(fruit.id.toString());
      }).toList();
      emit(FavoritesLoaded(fruits: _favoriteFruits));
    } catch (e) {
      emit(RecipeError(message: 'Failed to load favorites: $e'));
    }
  }

  void _onCreateRecipe(CreateRecipe event, Emitter<RecipeState> emit) async {
    try {
      final newRecipe = RecipeModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        fruits: event.fruits,
        createdAt: DateTime.now(),
      );
      await recipeRepository.saveRecipe(newRecipe);
      
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;
        final updatedRecipes = List<RecipeModel>.from(currentState.recipes)..add(newRecipe);
        emit(RecipesLoaded(recipes: updatedRecipes));
      } else {
        add(LoadRecipes());
      }
    } catch (e) {
      emit(RecipeError(message: 'Failed to create recipe: $e'));
    }
  }

  void _onDeleteRecipe(DeleteRecipe event, Emitter<RecipeState> emit) async {
    try {
      await recipeRepository.deleteRecipe(event.recipeId);
      
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;
        final updatedRecipes = currentState.recipes.where((recipe) => recipe.id != event.recipeId).toList();
        emit(RecipesLoaded(recipes: updatedRecipes));
      }
    } catch (e) {
      emit(RecipeError(message: 'Failed to delete recipe: $e'));
    }
  }

  void _onToggleFavorite(ToggleFavoriteRecipe event, Emitter<RecipeState> emit) async {
    try {
      final fruitId = event.fruitId.toString();
      final isCurrentlyFavorite = recipeRepository.isFavorite(fruitId);
      
      if (isCurrentlyFavorite) {
        await recipeRepository.removeFromFavorites(fruitId);
      } else {
        await recipeRepository.addToFavorites(fruitId);
      }
      
      // Reload favorites if we're on favorites screen
      if (state is FavoritesLoaded) {
        add(LoadFavorites());
      }
    } catch (e) {
      emit(RecipeError(message: 'Failed to toggle favorite: $e'));
    }
  }

  void _onLoadAllFruits(LoadAllFruits event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      _allFruits = await fruitRepository.getAllFruits();
      emit(AllFruitsLoaded(fruits: _allFruits));
    } catch (e) {
      emit(RecipeError(message: 'Failed to load fruits: $e'));
    }
  }

  List<FruitModel> getFavoriteFruits() {
    final favoriteIds = recipeRepository.getFavorites();
    return _allFruits.where((fruit) => favoriteIds.contains(fruit.id.toString())).toList();
  }
}