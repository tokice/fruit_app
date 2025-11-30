import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe/recipe_bloc.dart';
import 'create_recipe_page.dart';
import '../../data/models/recipe_model.dart';
import '../../data/models/fruit_model.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRecipePage()),
          );
        },
        child: const Icon(Icons.add),
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
                      context.read<RecipeBloc>().add(LoadRecipes());
                    },
                    child: const Text('Перезагрузить'),
                  ),
                ],
              ),
            );
          } else if (state is RecipesLoaded) {
            if (state.recipes.isEmpty) {
              return const Center(
                child: Text('Создайте свой первый рецепт'),
              );
            }

            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return _buildRecipeCard(context, recipe);
              },
            );
          } else {
            return const Center(child: Text('Загрузка рецептов...'));
          }
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, RecipeModel recipe) {
    final nutritions = recipe.totalNutritions;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<RecipeBloc>().add(DeleteRecipe(recipeId: recipe.id));
                  },
                ),
              ],
            ),
            if (recipe.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(recipe.description),
            ],
            const SizedBox(height: 12),
            Text(
              'Состав: ${recipe.fruitsString}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            _buildNutritionSummary(nutritions),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSummary(Nutritions nutritions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Питательная ценность:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 16,
          children: [
            _buildNutritionChip('${nutritions.calories} ккал', Icons.local_fire_department),
            _buildNutritionChip('${nutritions.protein} г белка', Icons.fitness_center),
            _buildNutritionChip('${nutritions.carbohydrates} г углеводов', Icons.energy_savings_leaf),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionChip(String text, IconData icon) {
    return Chip(
      label: Text(text),
      avatar: Icon(icon, size: 16),
      visualDensity: VisualDensity.compact,
    );
  }
}