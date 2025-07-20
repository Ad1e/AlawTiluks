import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.withAlpha(26),
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Colors.greenAccent.withAlpha(26),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(LucideIcons.info, size: 64, color: Colors.teal),
            ),
            const SizedBox(height: 24),

            // Project description container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(230),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About This Project",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Tilux is a mobile app made to help you keep an eye on your environment whether you’re managing a farm, a greenhouse, or just curious about air quality around you.\n\n"
                    "It connects to sensors that track temperature, humidity, gas, and smoke levels, and shows the data live in graphs that update every second. You can also look back at past readings, check the system’s battery and connection status, and even view the latest weather forecast for your area.\n\n"
                    "Whether you’re trying to spot dangerous air conditions early or just want to know how your system’s doing, Alaw Tiluk makes monitoring easy and visual all in the palm of your hand.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              "Key Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(
              text:
                  "Live monitoring of temperature, humidity, gas, and smoke levels.",
            ),
            const BulletPoint(
              text: "View historical sensor logs by date range.",
            ),
            const BulletPoint(
              text: "Check battery level, power source, and connection status.",
            ),
            const BulletPoint(
              text: "Get current weather conditions and 7-day forecast.",
            ),
            const SizedBox(height: 24),
            const Text(
              "Use Cases",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(
              text: "Smart agriculture and greenhouse monitoring",
            ),
            const BulletPoint(text: "Air quality tracking in Kitchen"),
            const BulletPoint(text: "Remote IoT system status monitoring"),
            const BulletPoint(text: "Educational projects and research"),
            const SizedBox(height: 24),
            const Text(
              "Developed By",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "The students of Batangas State University TNEU - Alangilan Campus, College of Informatics and Computing Sciences \nIlagan, Ulysis N. \nMazan, Aldwin C. \nMontalbo, Don Clifford I.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
