import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picklaundry/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/delivery_partner_model.dart';

class AdminService {

  static const String baseUrl =
      "${ApiConstants.baseUrl}";

  //------------------------------------------------------
  // TOKEN
  //------------------------------------------------------

  Future<String> _token() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString("accessToken") ?? "";

  }

  //------------------------------------------------------
  // GET ALL DELIVERY PARTNERS
  //------------------------------------------------------

  Future<List<DeliveryPartnerModel>>
      getDeliveryPartners() async {

    final token = await _token();

    final response = await http.get(

      Uri.parse(
        "$baseUrl/admin/delivery-partners",
      ),

      headers: {

        "Authorization": "Bearer $token",

        "Content-Type": "application/json",

      },

    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data

          .map(
            (e) =>
                DeliveryPartnerModel.fromJson(e),
          )

          .toList();

    }

    throw Exception(
      "Unable to load partners",
    );

  }

  //------------------------------------------------------
  // MARK AS PAID
  //------------------------------------------------------

  Future<void> markPartnerPaid(
      int partnerId) async {

    final token = await _token();

    final response = await http.put(

      Uri.parse(
        "$baseUrl/admin/partner/$partnerId/mark-paid",
      ),

      headers: {

        "Authorization": "Bearer $token",

        "Content-Type": "application/json",

      },

    );

    if (response.statusCode != 200) {

      throw Exception(
        "Payment Failed",
      );

    }

  }

}