import 'package:flutter/material.dart';

/// Skeleton UI showing weekly calendar structure during loading
class SkeletonCalendar extends StatelessWidget {
  const SkeletonCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week header
          const Center(
            child: Text(
              'This Week',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Days of the week
          for (int i = 0; i < 7; i++) _buildSkeletonDay(context, i),
        ],
      ),
    );
  }

  Widget _buildSkeletonDay(BuildContext context, int dayIndex) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          days[dayIndex],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Skeleton meal cards
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        if (dayIndex < 6) const Divider(height: 1),
      ],
    );
  }
}
