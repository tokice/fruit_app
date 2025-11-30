import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_app/data/local_storage/local_storage.dart';
import 'package:fruit_app/data/repositories/fruit_repository_impl.dart';
import 'package:fruit_app/data/repositories/recipe_repository_impl.dart';
import 'package:fruit_app/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = await LocalStorage.init();
  
  runApp(FruitApp(
    localStorage: localStorage,
  ));
}

class FruitApp extends StatelessWidget {
  final LocalStorage localStorage;

  const FruitApp({
    super.key,
    required this.localStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FruitRepositoryImpl>(
          create: (context) => FruitRepositoryImpl(),
        ),
        RepositoryProvider<RecipeRepositoryImpl>(
          create: (context) => RecipeRepositoryImpl(localStorage: localStorage),
        ),
      ],
      child: MaterialApp(
        title: 'Fruit App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
