import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picklaundry/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class OrderService {

  static const String baseUrl =
      "${ApiConstants.baseUrl}/orders";

  Future<Map<String, dynamic>> placeOrder(
      String token,
      Map<String, dynamic> body) async {

         print("========== TOKEN ==========");
  print(token);


    print("========== ORDER REQUEST ==========");
    print(jsonEncode(body));

    final response = await http.post(
      Uri.parse(baseUrl),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode(body),
    );

    print("========== STATUS ==========");
    print(response.statusCode);

    print("========== RESPONSE ==========");
    print(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return jsonDecode(response.body);

    } else {

      throw Exception(response.body);
    }
  }

  Future<List<OrderModel>> getMyOrders() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("$baseUrl"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {

    List data = jsonDecode(response.body);

    return data
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  throw Exception("Unable to load orders");
}

Future<int> getOrderCount() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("$baseUrl/order-count"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {

    return int.parse(response.body);

  }

  throw Exception("Unable to load order count");
}


Future<double> getTotalRevenue() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("$baseUrl/total-revenue"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return double.parse(response.body);
  }

  throw Exception("Unable to load revenue");
}

Future<int> getDeliveredCount() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString("accessToken");


  final response = await http.get(

    Uri.parse(
      "$baseUrl/delivered-count"
    ),

    headers: {

      "Authorization":
          "Bearer $token",

      "Content-Type":
          "application/json",

    },

  );


  if(response.statusCode == 200){

    return int.parse(response.body);

  }

  throw Exception(
      "Failed to load delivered count"
  );

}

Future<int> getPickupPendingCount() async {


  final prefs =
      await SharedPreferences.getInstance();


  final token =
      prefs.getString("accessToken");


  final response = await http.get(

    Uri.parse(
      "$baseUrl/pickup-pending-count"
    ),

    headers: {

      "Authorization":
      "Bearer $token",

      "Content-Type":
      "application/json",

    },

  );


  if(response.statusCode == 200){

    return int.parse(response.body);

  }


  throw Exception(
      "Failed to load pickup count"
  );

}

Future<List<OrderModel>> getAllOrders() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString("accessToken");

  final response = await http.get(

    Uri.parse(
      "$baseUrl/all"
    ),

    headers:{

      "Authorization":"Bearer $token",

      "Content-Type":"application/json",

    },

  );


  if(response.statusCode==200){

    List data=jsonDecode(response.body);

    return data
        .map((e)=>OrderModel.fromJson(e))
        .toList();

  }

  throw Exception("Unable to load orders");

}


}