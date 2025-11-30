import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/fruit_model.dart';
import '../bloc/recipe/recipe_bloc.dart';

class FruitCard extends StatelessWidget {
  final FruitModel fruit;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const FruitCard({
    super.key,
    required this.fruit,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<RecipeBloc, bool>(
      (bloc) => bloc.isFavorite(fruit.id.toString()),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Text(
            fruit.name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          fruit.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(fruit.family),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onToggleFavorite,
        ),
        onTap: onTap,
      ),
    );
  }
}