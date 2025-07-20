import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorGraph extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<double> data;
  final Color lineColor;
  final List<String>? timeLabels;

  const SensorGraph({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    required this.lineColor,
    this.timeLabels,
  });

  double _getInterval(List<double> data) {
    if (data.isEmpty) return 10;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    if (range <= 20) return 5;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 500) return 50;
    return 100;
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final minY = (data.isEmpty ? 0 : data.reduce((a, b) => a < b ? a : b) - 10)
        .clamp(0, double.infinity)
        .toDouble();
    final maxY =
        (data.isEmpty ? 100 : data.reduce((a, b) => a > b ? a : b) + 10)
            .toDouble();

    final average = data.isEmpty
        ? 0
        : (data.reduce((a, b) => a + b) / data.length).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // <-- Added margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          top: BorderSide(color: lineColor, width: 3), // <-- Dynamic top border
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with icon and labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: lineColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Avg: $average',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: lineColor.darken(0.2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Now: ${data.isNotEmpty ? data.last.toStringAsFixed(1) : "--"} at ${_getCurrentTime()}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                backgroundColor: Colors.transparent,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ), // Hide bottom (time)
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getInterval(data),
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(e.key.toDouble(), e.value.toDouble()),
                        )
                        .toList(),
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                      colors: [
                        lineColor.withAlpha((0.3 * 255).toInt()),
                        lineColor.withAlpha((0.05 * 255).toInt()),
                      ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension method to darken a color
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
