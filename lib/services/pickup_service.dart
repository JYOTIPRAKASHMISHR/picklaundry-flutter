import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picklaundry/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class PickupService {

  static const String baseUrl =
      "${ApiConstants.baseUrl}/orders";

 Future<List<OrderModel>> getPickupOrders() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  print("TOKEN = $token");

  final response = await http.get(
    Uri.parse("$baseUrl/pickup-pending"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print("STATUS = ${response.statusCode}");
  print("BODY = ${response.body}");

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);

    print("TOTAL ORDERS = ${data.length}");

    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  throw Exception("Unable to load orders");
}

Future<void> pickupOrder(String orderId) async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.put(
    Uri.parse("$baseUrl/$orderId/pickup"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) {
    throw Exception("Pickup failed");
  }
}

Future<void> outForDelivery(String orderId) async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.put(
    Uri.parse("$baseUrl/$orderId/out-for-delivery"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) {
    throw Exception("Out For Delivery failed");
  }
}

Future<void> delivered(String orderId) async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.put(
    Uri.parse("$baseUrl/$orderId/delivered"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) {
    throw Exception("Delivery failed");
  }
}

Future<List<OrderModel>> getDeliveryOrders() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("$baseUrl/delivery-orders"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {

    List data = jsonDecode(response.body);

    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  throw Exception("Unable to load delivery orders");
}

Future<List<OrderModel>> getProcessingOrders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("$baseUrl/processing-orders"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);

    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  throw Exception("No processing orders");
}

Future<void> processing(String orderId) async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.put(
    Uri.parse("$baseUrl/$orderId/processing"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to move Processing");
  }
}

Future<void> readyForDelivery(String orderId) async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.put(
    Uri.parse("$baseUrl/$orderId/ready"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to move Ready");
  }
}
Future<int> getPendingEarnings() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/orders/partner/pending-earnings"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  }

  throw Exception("Unable to load Pending Earnings");
}
Future<int> getTotalEarnings() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/orders/partner/total-earnings"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  }

  throw Exception("Unable to load Total Earnings");
}
Future<int> getCompletedOrders() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/orders/partner/completed-orders"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  }

  throw Exception("Unable to load Completed Orders");
}
}