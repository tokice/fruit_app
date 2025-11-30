import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_app/presentation/bloc/fruit/fruit_bloc.dart';
import '../../data/models/fruit_model.dart';
import '../bloc/recipe/recipe_bloc.dart';

class FruitDetailPage extends StatelessWidget {
  final FruitModel fruit;

  const FruitDetailPage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name),
        actions: [
          BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              final isFavorite = context.read<RecipeBloc>().isFavorite(fruit.id.toString());
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<RecipeBloc>().add(ToggleFavoriteFruit(fruitId: fruit.id) as RecipeEvent);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Семейство', fruit.family),
            _buildInfoCard('Порядок', fruit.order),
            _buildInfoCard('Род', fruit.genus),
            const SizedBox(height: 16),
            const Text(
              'Питательные свойства:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildNutritionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNutritionRow('Калории', '${fruit.nutritions.calories} ккал'),
            _buildNutritionRow('Жиры', '${fruit.nutritions.fat} г'),
            _buildNutritionRow('Сахар', '${fruit.nutritions.sugar} г'),
            _buildNutritionRow('Углеводы', '${fruit.nutritions.carbohydrates} г'),
            _buildNutritionRow('Белки', '${fruit.nutritions.protein} г'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}