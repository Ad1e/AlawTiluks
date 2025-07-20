import 'package:flutter/material.dart';
import '../services/weatherservice.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weather;
  List<Map<String, dynamic>>? _forecast;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final current = await _weatherService.fetchCurrentWeather(13.7567, 121.0584);
      final forecast = await _weatherService.fetchWeeklyForecast(13.7567, 121.0584);

      setState(() {
        _weather = current;
        _forecast = forecast;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = "Failed to load weather.";
        _loading = false;
      });
    }
  }

  IconData _getWeatherIcon(num temp, num rain, {num wind = 0, String? time}) {
    if (wind > 20) return Icons.air;
    if (rain > 10) return Icons.thunderstorm;
    if (rain > 0) return Icons.umbrella;
    if (temp >= 33) return Icons.wb_sunny;

    if (time != null) {
      final hour = DateTime.parse(time).hour;
      if (hour < 6 || hour > 18) {
        return Icons.nightlight_round;
      }
    }

    return Icons.cloud;
  }

  String _getConditionEmoji(num temp, num rain, num wind) {
    if (wind > 20) return "☁️ Windy";
    if (rain > 10) return "⛈ Stormy";
    if (rain > 0) return "🌧 Rainy";
    if (temp >= 33) return "🌤 Sunny";
    return "🌥 Mild";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.withAlpha(26), // ≈ 0.1
      appBar: AppBar(
        title: const Text("Weather"),
        backgroundColor: Colors.greenAccent.withAlpha(26),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeather,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 🌤 Current Weather Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          color: Colors.white.withAlpha(230), // ≈ 0.9
                          shadowColor: Colors.teal.withAlpha(77), // ≈ 0.3
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Emoji line
                                Text(
                                  _getConditionEmoji(
                                    _weather?['temperature'],
                                    0,
                                    _weather?['windspeed'],
                                  ).split(" ").first,
                                  style: const TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Batangas City",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Temperature: ${_weather?['temperature']} °C",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Wind: ${_weather?['windspeed']} km/h",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Time: ${_weather?['time']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "7-Day Forecast",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ..._forecast!.map((day) {
                          final temp = day['max_temp'] as num;
                          final rain = day['rain'] as num;
                          _getWeatherIcon(temp, rain);
                          final condition = _getConditionEmoji(temp, rain, 0);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            color: Colors.white.withAlpha(242), // ≈ 0.95
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Text(
                                condition.split(" ").first,
                                style: const TextStyle(fontSize: 28),
                              ),
                              title: Text(
                                day['date'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Max Temp: $temp °C | Rain: $rain mm | ${condition.split(" ").last}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
      ),
    );
  }
}
