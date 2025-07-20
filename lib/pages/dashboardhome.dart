import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'livedata.dart';
import 'log.dart';
import 'systemstatus.dart';
import 'weather.dart';
import 'about.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});
  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const LiveDataPage(),
    const LogPage(),
    const SystemStatusPage(),
    const WeatherPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(
            top: 32,
            left: 20,
            right: 20,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo + Title
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40), // Circular logo
                    child: Image.asset(
                      'assets/logo.png',
                      height: 82,
                      width: 82,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Tilux",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Help Icon
              IconButton(
                icon: const Icon(LucideIcons.helpCircle, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontFamily: 'NotoSans'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'NotoSans'),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.activity),
            label: "Live",
          ),
          BottomNavigationBarItem(icon: Icon(LucideIcons.list), label: "Logs"),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.server),
            label: "System",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.cloudSun),
            label: "Weather",
          ),
        ],
      ),
    );
  }
}
