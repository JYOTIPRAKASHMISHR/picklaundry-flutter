import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/service_item.dart';

class ApiService {
  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
    // "Authorization": "Bearer $token",
  };

  // ==========================================
  // GET ALL SERVICES
  // GET /api/services
  // ==========================================

  static Future<List<dynamic>> getServices() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/services"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load services");
  }

  // ==========================================
  // GET ITEMS OF SERVICE
  // GET /api/services/{serviceId}/items
  // ==========================================

  static Future<List<ServiceItem>> getItems(int serviceId) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/$serviceId/items",
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data
          .map((e) => ServiceItem.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load items");
  }

  // ==========================================
  // ADD ITEM
  // POST /api/services/items
  // ==========================================

  static Future<bool> addItem({
    required int serviceId,
    required String itemName,
    required double basePrice,
    required double expressPrice,
    required double premiumPrice,
    required double gst,
    required bool active,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/items",
      ),
      headers: _headers,
      body: jsonEncode({
        "serviceId": serviceId,
        "itemName": itemName,
        "basePrice": basePrice,
        "expressPrice": expressPrice,
        "premiumPrice": premiumPrice,
        "gst": gst,
        "active": active,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // ==========================================
  // UPDATE ITEM
  // PUT /api/services/items
  // ==========================================

  static Future<bool> updateItem({
    required int id,
    required String itemName,
    required double basePrice,
    required double expressPrice,
    required double premiumPrice,
    required double gst,
    required bool active,
  }) async {
    final response = await http.put(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/items",
      ),
      headers: _headers,
      body: jsonEncode({
       "itemId": id,
        "itemName": itemName,
        "basePrice": basePrice,
        "expressPrice": expressPrice,
        "premiumPrice": premiumPrice,
        "gst": gst,
        "active": active,
      }),
    );

    return response.statusCode == 200;
  }

  // ==========================================
  // DELETE ITEM
  // DELETE /api/services/items/{id}
  // ==========================================

  static Future<bool> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/items/$id",
      ),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  // ==========================================
  // CHANGE ITEM STATUS
  // PUT /api/services/items/{id}/status?active=true
  // ==========================================

  static Future<bool> changeItemStatus({
    required int id,
    required bool active,
  }) async {
    final response = await http.put(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/items/$id/status?active=$active",
      ),
      headers: _headers,
    );

    return response.statusCode == 200;
  }

  // ==========================================
  // CHANGE SERVICE STATUS
  // PUT /api/services/{id}/status?active=true
  // ==========================================

  static Future<bool> changeServiceStatus({
    required int id,
    required bool active,
  }) async {
    final response = await http.put(
      Uri.parse(
        "${ApiConstants.baseUrl}/services/$id/status?active=$active",
      ),
      headers: _headers,
    );

    return response.statusCode == 200;
  }
}