import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fruit_model.dart';

class FruitRemoteDataSource {
  static const String baseUrl = 'https://www.fruityvice.com/api/fruit';

  Future<List<FruitModel>> getAllFruits() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((fruitJson) => FruitModel.fromJson(fruitJson)).toList();
      } else {
        throw Exception('Failed to load fruits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load fruits: $e');
    }
  }
}