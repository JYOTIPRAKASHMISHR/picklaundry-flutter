// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/weather_model.dart';

// class WeatherService {
//   static const String apiKey = "eadfcdf82fe024becca9b588995144c6";

//  static Future<WeatherModel> getWeather() async {
//     final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/weather?q=Bhubaneswar&appid=$apiKey&units=metric",
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to load weather");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const String apiKey =
      "eadfcdf82fe024becca9b588995144c6"; // Replace with your API key

static Future<WeatherModel> getWeather() async {
  final url = Uri.parse(
    "https://api.openweathermap.org/data/2.5/weather?q=Bhubaneswar&appid=$apiKey&units=metric",
  );

  final response = await http.get(url);

  print(response.statusCode);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    return WeatherModel.fromJson(json);
  }

  throw Exception("Failed to load weather");
}

}
