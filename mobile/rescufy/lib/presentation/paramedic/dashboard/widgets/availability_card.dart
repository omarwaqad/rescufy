import 'package:flutter/material.dart';

class AvailabilityCard extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggle;

  const AvailabilityCard({
    super.key,
    required this.isOnline,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(isOnline ? "ONLINE" : "OFFLINE"),
        trailing: Switch(value: isOnline, onChanged: (_) => onToggle()),
      ),
    );
  }
}
