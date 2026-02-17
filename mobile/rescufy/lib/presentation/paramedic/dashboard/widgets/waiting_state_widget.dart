import 'package:flutter/material.dart';

class WaitingStateWidget extends StatelessWidget {
  const WaitingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Waiting for emergency requests..."));
  }
}
