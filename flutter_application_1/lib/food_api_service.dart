import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class FoodApiService {
  final String _appId = dotenv.env['APP_ID'] ?? '';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';
  final String _baseUrl = "https://api.edamam.com/api/food-database/v2/parser";

  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    final url = "$_baseUrl?ingr=$query&app_id=$_appId&app_key=$_apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['hints'] ?? []);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
