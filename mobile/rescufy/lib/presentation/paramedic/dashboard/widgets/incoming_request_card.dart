import 'package:flutter/material.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';

class IncomingRequestCard extends StatelessWidget {
  final IncomingRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _severityColor(request.severity).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              request.condition,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Severity: ${request.severity}"),
            Text("Distance: ${request.distanceKm} km"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text("Accept"),
                ),
                OutlinedButton(
                  onPressed: onReject,
                  child: const Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
