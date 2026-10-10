import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clear":
        return Icons.wb_sunny;

      case "clouds":
        return Icons.cloud;

      case "rain":
        return Icons.grain;

      case "drizzle":
        return Icons.grain;

      case "thunderstorm":
        return Icons.flash_on;

      case "snow":
        return Icons.ac_unit;

      case "mist":
      case "fog":
      case "haze":
        return Icons.blur_on;

      default:
        return Icons.cloud;
    }
  }

  Color getTopColor(String condition) {
    switch (condition.toLowerCase()) {
      case "clear":
        return const Color(0xffFFB703);

      case "clouds":
        return const Color(0xff64748B);

      case "rain":
        return const Color(0xff2563EB);

      case "thunderstorm":
        return const Color(0xff7C3AED);

      default:
        return const Color(0xff6D28D9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            getTopColor(weather.mainCondition),
            const Color(0xff0F172A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getWeatherIcon(weather.mainCondition),
              size: 55,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 22),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "${weather.temperature.toStringAsFixed(1)}°C",
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  weather.condition.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      weather.city,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

               Row(
  children: [

    Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.water_drop,
              color: Colors.cyanAccent,
              size: 18,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                "${weather.humidity}%",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.air,
              color: Colors.white,
              size: 18,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                "${weather.windSpeed.toStringAsFixed(1)} m/s",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),

  ],
)
              ],
            ),
          )
        ],
      ),
    );
  }
}