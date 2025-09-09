import 'package:flutter/material.dart';

/// Loading indicator widget with descriptive text
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.message = 'Generating your meal plan...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
