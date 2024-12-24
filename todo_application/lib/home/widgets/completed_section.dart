import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:todo_application/api/api.dart';

import 'reminder_list.dart';

class CompletedSection extends StatelessWidget {
  final AsyncValue<List<ReminderModel>> completedRemindersAsyncValue;
  final DateTime currentTime;

  const CompletedSection({
    super.key,
    required this.completedRemindersAsyncValue,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Completed",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Gap(16),
        completedRemindersAsyncValue.when(
          data: (reminders) {
            return ReminderList(
              reminders: reminders,
              currentTime: currentTime,
              isCompleted: true,
            );
          },
          error: (_, __) => const Center(
            child: Text('Failed to load reminders'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
