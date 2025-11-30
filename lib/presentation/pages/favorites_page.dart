import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_app/presentation/bloc/fruit/fruit_bloc.dart';
import '../bloc/recipe/recipe_bloc.dart';
import '../widgets/fruit_card.dart';
import 'fruit_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecipeBloc>().add(LoadFavorites());
                    },
                    child: const Text('Перезагрузить'),
                  ),
                ],
              ),
            );
          } else if (state is FavoritesLoaded) {
            if (state.fruits.isEmpty) {
              return const Center(
                child: Text('Вы пока ничего не добавили в избранное'),
              );
            }

            return ListView.builder(
              itemCount: state.fruits.length,
              itemBuilder: (context, index) {
                final fruit = state.fruits[index];
                return FruitCard(
                  fruit: fruit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FruitDetailPage(fruit: fruit),
                      ),
                    );
                  },
                  onToggleFavorite: () {
                    context.read<RecipeBloc>().add(
                      ToggleFavoriteFruit(fruitId: fruit.id) as RecipeEvent,
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Загрузка избранного...'));
          }
        },
      ),
    );
  }
}