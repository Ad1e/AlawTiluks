import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class LogTile extends StatelessWidget {
  final String message;
  final String time;
  final bool isDanger;
  final IconData? icon;

  const LogTile({
    required this.message,
    required this.time,
    required this.isDanger,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDanger ? Colors.red.shade50 : Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: isDanger
          ? Colors.redAccent.withAlpha((0.2 * 255).toInt())
          : Colors.greenAccent.withAlpha((0.2 * 255).toInt()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isDanger ? Colors.red : Colors.green,
          child: Icon(
            icon ??
                (isDanger ? LucideIcons.alertOctagon : LucideIcons.checkCircle),
            color: Colors.white,
          ),
        ),
        title: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  bool sortDescending = true;

  Future<void> _exportToCSV(List<QueryDocumentSnapshot> docs) async {
    List<List<dynamic>> rows = [
      ["Time", "Message", "Level"],
    ];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
      rows.add([
        DateFormat.yMd().add_jm().format(timestamp ?? DateTime.now()),
        data['message'],
        data['level'],
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/logs_export.csv";
    final file = File(path);
    await file.writeAsString(const ListToCsvConverter().convert(rows));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logs exported to $path"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Logs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            onPressed: () => setState(() => sortDescending = !sortDescending),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance
                  .collection('logs')
                  .orderBy('timestamp', descending: sortDescending)
                  .get();
              _exportToCSV(snapshot.docs);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('logs')
            .orderBy('timestamp', descending: sortDescending)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final time = (data['timestamp'] as Timestamp?)?.toDate();
              final formatted = time != null
                  ? DateFormat.jm().format(time)
                  : "";
              final isDanger = data['level'] == 'danger';

              return LogTile(
                message: data['message'] ?? '',
                time: formatted,
                isDanger: isDanger,
                icon: isDanger ? LucideIcons.flame : LucideIcons.info,
              );
            },
          );
        },
      ),
    );
  }
}
