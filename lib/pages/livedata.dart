import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/sensorgraph.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  late Timer _timer;
  final int maxLength = 20;

  List<double> tempData = [];
  List<double> humidityData = [];
  List<double> gasData = [];
  List<double> smokeData = [];

  List<String> timeLabels = [];

  @override
  void initState() {
    super.initState();
    _generateInitialData();
    _startLiveUpdate();
  }

  void _generateInitialData() {
    final now = DateTime.now();
    for (int i = 0; i < maxLength; i++) {
      tempData.add(25 + Random().nextDouble() * 5);
      humidityData.add(50 + Random().nextDouble() * 10);
      gasData.add(100 + Random().nextDouble() * 50);
      smokeData.add(30 + Random().nextDouble() * 20);
      timeLabels.add(
        _formatTime(now.subtract(Duration(seconds: (maxLength - i)))),
      );
    }
  }

  String _formatTime(DateTime dt) =>
      "${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";

  void _startLiveUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      setState(() {
        tempData = _pushNew(tempData, 25 + Random().nextDouble() * 5);
        humidityData = _pushNew(humidityData, 50 + Random().nextDouble() * 10);
        gasData = _pushNew(gasData, 100 + Random().nextDouble() * 50);
        smokeData = _pushNew(smokeData, 30 + Random().nextDouble() * 20);
        timeLabels = _pushNew(timeLabels, _formatTime(now));
      });
    });
  }

  List<T> _pushNew<T>(List<T> list, T value) {
    final newList = List<T>.from(list);
    if (newList.length >= maxLength) newList.removeAt(0);
    newList.add(value);
    return newList;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.withAlpha(26),
      appBar: AppBar(
        title: const Text('Live Sensor Data'),
        backgroundColor: Colors.blueGrey.withAlpha(26),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        children: [
          SensorGraph(
            title: 'Temperature',
            icon: Icons.thermostat,
            lineColor: Colors.orangeAccent,
            data: tempData,
            timeLabels: timeLabels,
          ),
          const SizedBox(height: 16),
          SensorGraph(
            title: 'Humidity',
            icon: Icons.water_drop,
            lineColor: Colors.blueAccent,
            data: humidityData,
            timeLabels: timeLabels,
          ),
          const SizedBox(height: 16),
          SensorGraph(
            title: 'Gas',
            icon: Icons.warning_amber_rounded,
            lineColor: Colors.deepPurpleAccent,
            data: gasData,
            timeLabels: timeLabels,
          ),
          const SizedBox(height: 16),
          SensorGraph(
            title: 'Smoke',
            icon: Icons.smoking_rooms,
            lineColor: Colors.grey,
            data: smokeData,
            timeLabels: timeLabels,
          ),
        ],
      ),
    );
  }
}
