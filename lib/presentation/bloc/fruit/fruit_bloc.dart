import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fruit_app/data/models/fruit_model.dart';
import 'package:fruit_app/data/repositories/fruit_repository_impl.dart';
import 'package:fruit_app/data/repositories/recipe_repository_impl.dart';

// Events
abstract class FruitEvent extends Equatable {
  const FruitEvent();

  @override
  List<Object> get props => [];
}

class LoadFruits extends FruitEvent {}

class ToggleFavoriteFruit extends FruitEvent {
  final int fruitId;

  const ToggleFavoriteFruit({required this.fruitId});

  @override
  List<Object> get props => [fruitId];
}

class SortFruits extends FruitEvent {
  final FruitSortType sortType;

  const SortFruits({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class FilterFruits extends FruitEvent {
  final Set<FruitFilter> filters;

  const FilterFruits({required this.filters});

  @override
  List<Object> get props => [filters];
}

enum FruitSortType {
  nameAsc,
  nameDesc,
  caloriesAsc,
  caloriesDesc,
}

enum FruitFilter {
  highProtein,
  lowSugar,
  highCalories,
  lowCalories,
}

// States
abstract class FruitState extends Equatable {
  const FruitState();

  @override
  List<Object> get props => [];
}

class FruitInitial extends FruitState {}

class FruitLoading extends FruitState {}

class FruitLoaded extends FruitState {
  final List<FruitModel> fruits;

  const FruitLoaded({required this.fruits});

  FruitLoaded copyWith({
    List<FruitModel>? fruits,
  }) {
    return FruitLoaded(
      fruits: fruits ?? this.fruits,
    );
  }

  @override
  List<Object> get props => [fruits];
}

class FruitError extends FruitState {
  final String message;

  const FruitError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class FruitBloc extends Bloc<FruitEvent, FruitState> {
  final FruitRepositoryImpl fruitRepository;
  final RecipeRepositoryImpl recipeRepository;
  
  List<FruitModel> _allFruits = [];

  FruitBloc({
    required this.fruitRepository,
    required this.recipeRepository,
  }) : super(FruitInitial()) {
    on<LoadFruits>(_onLoadFruits);
    on<ToggleFavoriteFruit>(_onToggleFavorite);
    on<SortFruits>(_onSortFruits);
    on<FilterFruits>(_onFilterFruits);
  }

  void _onLoadFruits(LoadFruits event, Emitter<FruitState> emit) async {
    emit(FruitLoading());
    try {
      _allFruits = await fruitRepository.getAllFruits();
      emit(FruitLoaded(fruits: _allFruits));
    } catch (e) {
      emit(FruitError(message: 'Failed to load fruits: $e'));
    }
  }

  void _onToggleFavorite(ToggleFavoriteFruit event, Emitter<FruitState> emit) {
    if (state is FruitLoaded) {
      final currentState = state as FruitLoaded;
      final isCurrentlyFavorite = recipeRepository.isFavorite(event.fruitId.toString());
      
      if (isCurrentlyFavorite) {
        recipeRepository.removeFromFavorites(event.fruitId.toString());
      } else {
        recipeRepository.addToFavorites(event.fruitId.toString());
      }
      
      emit(currentState.copyWith());
    }
  }

  void _onSortFruits(SortFruits event, Emitter<FruitState> emit) {
    if (state is FruitLoaded) {
      final currentState = state as FruitLoaded;
      List<FruitModel> sortedFruits = List.from(currentState.fruits);
      
      switch (event.sortType) {
        case FruitSortType.nameAsc:
          sortedFruits.sort((a, b) => a.name.compareTo(b.name));
        case FruitSortType.nameDesc:
          sortedFruits.sort((a, b) => b.name.compareTo(a.name));
        case FruitSortType.caloriesAsc:
          sortedFruits.sort((a, b) => a.nutritions.calories.compareTo(b.nutritions.calories));
        case FruitSortType.caloriesDesc:
          sortedFruits.sort((a, b) => b.nutritions.calories.compareTo(a.nutritions.calories));
      }
      
      emit(currentState.copyWith(fruits: sortedFruits));
    }
  }

  void _onFilterFruits(FilterFruits event, Emitter<FruitState> emit) {
    if (state is FruitLoaded) {
      List<FruitModel> filteredFruits = _allFruits;
      
      // Apply filters
      if (event.filters.contains(FruitFilter.highProtein)) {
        filteredFruits = filteredFruits.where((fruit) => fruit.nutritions.protein > 1.0).toList();
      }
      if (event.filters.contains(FruitFilter.lowSugar)) {
        filteredFruits = filteredFruits.where((fruit) => fruit.nutritions.sugar < 10.0).toList();
      }
      if (event.filters.contains(FruitFilter.highCalories)) {
        filteredFruits = filteredFruits.where((fruit) => fruit.nutritions.calories > 50.0).toList();
      }
      if (event.filters.contains(FruitFilter.lowCalories)) {
        filteredFruits = filteredFruits.where((fruit) => fruit.nutritions.calories < 50.0).toList();
      }
      
      emit(FruitLoaded(fruits: filteredFruits));
    }
  }
}