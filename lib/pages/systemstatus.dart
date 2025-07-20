import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SystemStatusPage extends StatefulWidget {
  const SystemStatusPage({super.key});

  @override
  State<SystemStatusPage> createState() => _SystemStatusPageState();
}

class _SystemStatusPageState extends State<SystemStatusPage> {
  bool isSolar = true;
  double batteryPercentage = 16.0;
  String connectionStatus = "Disconnected";
  bool isReconnecting = false;

  String currentWeatherCondition = "Cloudy";

  String get _lastUpdated {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  bool get isBadWeather {
    return currentWeatherCondition == "Rainy" ||
        currentWeatherCondition == "Cloudy";
  }

  void _reconnect() async {
    setState(() {
      isReconnecting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      connectionStatus = "Connected";
      isReconnecting = false;
    });
  }

  void _refreshStatus() {
    setState(() {
      batteryPercentage = (batteryPercentage - 3).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLow = batteryPercentage < 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Status'),
        backgroundColor: const Color.fromRGBO(144, 238, 144, 0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Status',
            onPressed: _refreshStatus,
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(144, 238, 144, 0.1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _glassCard(
              icon: LucideIcons.wifi,
              title: "Connection",
              subtitle: connectionStatus,
              iconColor: connectionStatus == "Connected"
                  ? Colors.green
                  : Colors.redAccent,
              trailing: connectionStatus == "Connected"
                  ? Text(
                      "Connected at $_lastUpdated",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: isReconnecting ? null : _reconnect,
                      icon: isReconnecting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh, size: 16),
                      label: const Text("Reconnect"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            _glassCard(
              icon: isSolar ? LucideIcons.sun : LucideIcons.batteryCharging,
              iconColor: isSolar ? Colors.orange : Colors.blue,
              title: "Power Source",
              subtitle: isSolar ? "Solar Power" : "Battery Power",
              trailing: Switch.adaptive(
                value: isSolar,
                activeColor: Colors.teal,
                onChanged: (val) {
                  if (!val && batteryPercentage < 15) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Low Battery"),
                        content: const Text(
                          "Battery too low to disable solar power.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  setState(() => isSolar = val);
                },
              ),
              content: isSolar && isBadWeather
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Current weather conditions may not sustain solar power. Consider switching to battery.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            _glassCard(
              icon: LucideIcons.batteryCharging,
              iconColor: isLow ? Colors.redAccent : Colors.green,
              title: "Battery",
              subtitle: "${batteryPercentage.toInt()}%",
              trailing: Text(
                "Updated at $_lastUpdated",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: LinearProgressIndicator(
                        value: batteryPercentage / 100,
                        minHeight: 14,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isLow
                              ? Colors.redAccent
                              : const Color.fromRGBO(144, 238, 144, 0.5),
                        ),
                      ),
                    ),
                  ),
                  if (isLow)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Battery low. Consider switching to solar.",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Widget? trailing,
    Widget? content,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(255, 255, 255, 0.85),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 26, color: iconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (trailing != null) trailing,
                  ],
                ),
                if (content != null) content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
