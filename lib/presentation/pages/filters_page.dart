import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/fruit/fruit_bloc.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  FruitSortType _selectedSort = FruitSortType.nameAsc;
  final Set<FruitFilter> _selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры и сортировка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сортировка',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSortOptions(),
            const SizedBox(height: 24),
            const Text(
              'Фильтры',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFilterOptions(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Применить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: FruitSortType.values.map((sortType) {
        return RadioListTile<FruitSortType>(
          title: Text(_getSortLabel(sortType)),
          value: sortType,
          groupValue: _selectedSort,
          onChanged: (value) {
            setState(() {
              _selectedSort = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFilterOptions() {
    return Column(
      children: FruitFilter.values.map((filter) {
        return CheckboxListTile(
          title: Text(_getFilterLabel(filter)),
          value: _selectedFilters.contains(filter),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedFilters.add(filter);
              } else {
                _selectedFilters.remove(filter);
              }
            });
          },
        );
      }).toList(),
    );
  }

  String _getSortLabel(FruitSortType sortType) {
    switch (sortType) {
      case FruitSortType.nameAsc:
        return 'По названию (А-Я)';
      case FruitSortType.nameDesc:
        return 'По названию (Я-А)';
      case FruitSortType.caloriesAsc:
        return 'По калориям (возрастание)';
      case FruitSortType.caloriesDesc:
        return 'По калориям (убывание)';
    }
  }

  String _getFilterLabel(FruitFilter filter) {
    switch (filter) {
      case FruitFilter.highProtein:
        return 'Высокое содержание белка (>1г)';
      case FruitFilter.lowSugar:
        return 'Низкое содержание сахара (<10г)';
      case FruitFilter.highCalories:
        return 'Высококалорийные (>50 ккал)';
      case FruitFilter.lowCalories:
        return 'Низкокалорийные (<50 ккал)';
    }
  }

  void _applyFilters() {
    context.read<FruitBloc>().add(SortFruits(sortType: _selectedSort));
    context.read<FruitBloc>().add(FilterFruits(filters: _selectedFilters));
    Navigator.pop(context);
  }
}