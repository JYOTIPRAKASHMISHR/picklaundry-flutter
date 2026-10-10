class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final String mainCondition;
  final String icon;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.mainCondition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["name"] ?? "",

      temperature:
          (json["main"]["temp"] as num).toDouble(),

      humidity:
          json["main"]["humidity"] ?? 0,

      windSpeed:
          (json["wind"]["speed"] as num).toDouble(),

      mainCondition:
          json["weather"][0]["main"] ?? "",

      condition:
          json["weather"][0]["description"] ?? "",

      icon:
          json["weather"][0]["icon"] ?? "",
    );
  }
}