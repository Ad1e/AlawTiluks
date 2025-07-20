import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/logtile.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

enum LogFilter { today, last7days, last30days }

class _LogPageState extends State<LogPage> {
  LogFilter _selectedFilter = LogFilter.today;

  DateTime getStartDate() {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case LogFilter.today:
        return DateTime(now.year, now.month, now.day);
      case LogFilter.last7days:
        return now.subtract(const Duration(days: 7));
      case LogFilter.last30days:
        return now.subtract(const Duration(days: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    final startDate = getStartDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Logs"),
        backgroundColor: Colors.greenAccent.withAlpha((0.1 * 255).toInt()), // updated
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: LogFilter.values.map((filter) {
                String label;
                switch (filter) {
                  case LogFilter.today:
                    label = "Today";
                    break;
                  case LogFilter.last7days:
                    label = "Last 7 Days";
                    break;
                  case LogFilter.last30days:
                    label = "Last 30 Days";
                    break;
                }

                final isSelected = _selectedFilter == filter;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Colors.green
                        : Colors.grey.shade300,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Text(label),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sensor_data')
                  .where(
                    'timestamp',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
                  )
                  .orderBy('timestamp', descending: true)
                  .limit(100)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No logs found for this period.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final smoke = (data['smoke'] ?? 0).toDouble();
                    final gas = (data['gas'] ?? 0).toDouble();
                    final temp = data['temperature'] ?? '--';
                    final time =
                        (data['timestamp'] as Timestamp?)?.toDate() ??
                        DateTime.now();
                    final formattedTime =
                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

                    final isDanger = smoke > 50 || gas > 400;
                    final msg = isDanger
                        ? "⚠️ DANGER: Smoke=${smoke.toStringAsFixed(1)}, Gas=${gas.toStringAsFixed(0)}"
                        : "✅ Normal update: Temp=$temp °C";

                    return LogTile(
                      message: msg,
                      time: formattedTime,
                      isDanger: isDanger,
                      icon: isDanger
                          ? LucideIcons.zap
                          : LucideIcons.thermometer,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
