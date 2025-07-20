import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,windspeed_10m&timezone=auto',
      ),
    );
    final data = json.decode(response.body);
    return {
      'temperature': data['current']['temperature_2m'],
      'windspeed': data['current']['windspeed_10m'],
      'time': data['current']['time'],
    };
  }

  Future<List<Map<String, dynamic>>> fetchWeeklyForecast(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl?latitude=$lat&longitude=$lon&daily=temperature_2m_max,precipitation_sum&hourly=temperature_2m,precipitation&timezone=auto',
      ),
    );
    final data = json.decode(response.body);

    final List<String> times = List<String>.from(data['hourly']['time']);
    final List hourlyTemps = data['hourly']['temperature_2m'];
    final List hourlyRain = data['hourly']['precipitation'];

    // Group hourly by day
    final Map<String, List<Map<String, dynamic>>> hourlyByDay = {};
    for (int i = 0; i < times.length; i++) {
      final fullTime = DateTime.parse(times[i]);
      final dateKey = fullTime.toIso8601String().split('T').first;
      final hour = "${fullTime.hour.toString().padLeft(2, '0')}:00";

      final hourData = {
        'time': hour,
        'temp': hourlyTemps[i],
        'rain': hourlyRain[i],
      };

      hourlyByDay.putIfAbsent(dateKey, () => []).add(hourData);
    }

    final List<Map<String, dynamic>> forecast = List.generate(
      data['daily']['time'].length,
      (i) {
        final date = data['daily']['time'][i];
        return {
          'date': date,
          'max_temp': data['daily']['temperature_2m_max'][i],
          'rain': data['daily']['precipitation_sum'][i],
          'hourly': hourlyByDay[date] ?? [],
        };
      },
    );

    return forecast;
  }
}
