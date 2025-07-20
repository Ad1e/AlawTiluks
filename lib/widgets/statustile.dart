import 'package:flutter/material.dart';

class StatusTile extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;
  final Color color;

  const StatusTile(this.title, this.status, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: color.withAlpha((0.2 * 255).toInt()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: CircleAvatar(
        backgroundColor: color.withAlpha((0.1 * 255).toInt()),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          status,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
