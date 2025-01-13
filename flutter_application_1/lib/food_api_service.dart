import 'dart:convert';
import 'package:flutter_application_1/model/meal.dart';
import 'package:http/http.dart' as http;

class FoodApiService {
  final String baseUrl = "https://api.edamam.com/api/food-database/v2/parser";
  final String appId = "d429884a"; // Vaše APP_ID
  final String appKey = "c6e689277453b122aeb5923cd7854e87"; // Vaše APP_KEY

  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?ingr=$query&app_id=$appId&app_key=$appKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['hints'] != null && data['hints'].isNotEmpty) {
          return List<Map<String, dynamic>>.from(data['hints']);
        } else {
          return [];
        }
      } else {
        throw Exception(
            "Chyba: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Chyba při načítání dat z API: $e");
    }
  }

// } catch (e) {
//   throw Exception("Chyba při načítání dat z API: $e");
// }
}