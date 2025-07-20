import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/legenditem.dart';

class MultiSensorGraph extends StatelessWidget {
  final List<double> gas, smoke, humidity, temperature;

  const MultiSensorGraph({
    super.key,
    required this.gas,
    required this.smoke,
    required this.humidity,
    required this.temperature,
  });

  LineChartBarData _line(List<double> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sensor Trends",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        return Text(
                          'T${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 20),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  _line(gas, Colors.deepPurple),
                  _line(smoke, Colors.grey),
                  _line(humidity, Colors.blue),
                  _line(temperature, Colors.orange),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            children: const [
              LegendItem(color: Colors.deepPurple, label: "Gas"),
              LegendItem(color: Colors.grey, label: "Smoke"),
              LegendItem(color: Colors.blue, label: "Humidity"),
              LegendItem(color: Colors.orange, label: "Temperature"),
            ],
          ),
        ],
      ),
    );
  }
}
