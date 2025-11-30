import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/fruit/fruit_bloc.dart';
import '../bloc/recipe/recipe_bloc.dart';
import 'fruits_page.dart';
import 'favorites_page.dart';
import 'recipes_page.dart';
import '../../data/repositories/fruit_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider<FruitBloc>(
          create: (context) => FruitBloc(
            fruitRepository: RepositoryProvider.of<FruitRepositoryImpl>(context),
            recipeRepository: RepositoryProvider.of<RecipeRepositoryImpl>(context),
          )..add(LoadFruits()),
        ),
      ],
      child: const FruitsPage(),
    ),
    BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc(
        recipeRepository: RepositoryProvider.of<RecipeRepositoryImpl>(context),
        fruitRepository: RepositoryProvider.of<FruitRepositoryImpl>(context),
      )..add(LoadFavorites()),
      child: const FavoritesPage(),
    ),
    BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc(
        recipeRepository: RepositoryProvider.of<RecipeRepositoryImpl>(context),
        fruitRepository: RepositoryProvider.of<FruitRepositoryImpl>(context),
      )..add(LoadRecipes()),
      child: const RecipesPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Фрукты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Рецепты',
          ),
        ],
      ),
    );
  }
}