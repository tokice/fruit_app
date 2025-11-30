import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/fruit_model.dart';
import '../bloc/recipe/recipe_bloc.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<FruitModel> _selectedFruits = {};

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(LoadAllFruits());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание рецепта'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название рецепта*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание рецепта',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Выберите фрукты из избранного:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  final favoriteFruits = context.read<RecipeBloc>().getFavoriteFruits();
                  
                  if (favoriteFruits.isEmpty) {
                    return const Center(
                      child: Text('Добавьте фрукты в избранное, чтобы создать рецепт'),
                    );
                  }

                  return ListView.builder(
                    itemCount: favoriteFruits.length,
                    itemBuilder: (context, index) {
                      final fruit = favoriteFruits[index];
                      final isSelected = _selectedFruits.contains(fruit);
                      
                      return Card(
                        child: CheckboxListTile(
                          title: Text(fruit.name),
                          subtitle: Text('${fruit.nutritions.calories} ккал'),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedFruits.add(fruit);
                              } else {
                                _selectedFruits.remove(fruit);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Сохранить рецепт'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRecipe() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название рецепта')),
      );
      return;
    }

    if (_selectedFruits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один фрукт')),
      );
      return;
    }

    context.read<RecipeBloc>().add(
      CreateRecipe(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        fruits: _selectedFruits.toList(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}