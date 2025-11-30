import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/fruit_detail_page.dart';
import '../pages/filters_page.dart';
import '../pages/create_recipe_page.dart';
import '../../data/models/fruit_model.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/fruit/:id',
        builder: (context, state) {
          final fruit = state.extra as FruitModel;
          return FruitDetailPage(fruit: fruit);
        },
      ),
      GoRoute(
        path: '/filters',
        builder: (context, state) => const FiltersPage(),
      ),
      GoRoute(
        path: '/create-recipe',
        builder: (context, state) => const CreateRecipePage(),
      ),
    ],
  );
}