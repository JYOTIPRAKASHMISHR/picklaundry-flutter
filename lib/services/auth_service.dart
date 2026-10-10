import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picklaundry/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

class AuthService {

 Future<Map<String, dynamic>> login({
  required String mobile,
  required String password,
}) async {

final response = await http.post(
  Uri.parse(
    "${ApiConstants.baseUrl}/auth/login",
  ),
  headers:{
    "Content-Type":"application/json",
  },
  body:jsonEncode({
    "mobile":mobile,
    "password":password,
  }),
);


print(response.statusCode);
print(response.body);


if(response.statusCode == 200){

 final data=jsonDecode(response.body);


 final prefs =
 await SharedPreferences.getInstance();


 await prefs.setString(
   "accessToken",
   data["accessToken"]
 );


 await prefs.setString(
   "refreshToken",
   data["refreshToken"]
 );


 await prefs.setString(
   "role",
   data["role"]
 );


 await prefs.setInt(
   "userId",
   data["userId"]
 );


 return data;

}


throw Exception(
 "Login Failed ${response.body}"
);

}

  Future<String> registerCustomer({
  required String fullName,
  required String email,
  required String mobile,
  required String password,
}) async {

  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/auth/register/customer"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "fullName": fullName,
      "email": email,
      "mobile": mobile,
      "password": password,
    }),
  );
  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200||
      response.statusCode == 201) {
    return response.body;
  }

  throw Exception("Customer Registration Failed");
}

Future<String> registerPartner({
  required String fullName,
  required String email,
  required String mobile,
  required String password,
  
}) async {

  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/auth/register/partner"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "fullName": fullName,
      "email": email,
      "mobile": mobile,
      "password": password,
      
    }),
  );
  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200||
      response.statusCode == 201) {
    return response.body;
  }

  throw Exception("Partner Registration Failed");
}

Future<int> getUserCount() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("accessToken");

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/auth/user-count"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Unable to fetch user count");
}

Future<List<UserModel>> getAllUsers() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString("accessToken");


  if(token == null){
    throw Exception("Token missing");
  }


  final response =
      await http.get(

    Uri.parse(
      "${ApiConstants.baseUrl}/auth/users"
    ),

    headers: {

      "Authorization":
          "Bearer $token",

      "Content-Type":
          "application/json",
    },

  );


  print("USER API STATUS : ${response.statusCode}");
  print("USER RESPONSE : ${response.body}");


  if(response.statusCode == 200){

    List data =
        jsonDecode(response.body);


    return data
        .map(
          (e)=>UserModel.fromJson(e)
        )
        .toList();

  }


  throw Exception(
      "Unable to load users ${response.body}"
  );

}
}