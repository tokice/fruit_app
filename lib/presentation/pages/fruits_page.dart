import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/fruit/fruit_bloc.dart';
import '../widgets/fruit_card.dart';
import 'fruit_detail_page.dart';
import 'filters_page.dart';

class FruitsPage extends StatelessWidget {
  const FruitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фрукты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FiltersPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FruitBloc, FruitState>(
        builder: (context, state) {
          if (state is FruitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FruitError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FruitBloc>().add(LoadFruits());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          } else if (state is FruitLoaded) {
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
                    context.read<FruitBloc>().add(
                      ToggleFavoriteFruit(fruitId: fruit.id),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Начните загрузку фруктов'));
          }
        },
      ),
    );
  }
}