import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/home/home.dart';

class ReminderList extends ConsumerWidget {
  final List<ReminderModel> reminders;
  final DateTime currentTime;
  final bool isCompleted;
  final bool showLabel;

  const ReminderList({
    super.key,
    required this.reminders,
    required this.currentTime,
    required this.isCompleted,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reminders.isEmpty) {
      return Center(
        child: Text(
          isCompleted ? 'No completed reminders' : 'No pending reminders',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    final sortedReminders = _sortReminders(reminders);

    return Column(
      children: sortedReminders
          .map(
            (reminder) => ReminderCard(
              reminder: reminder,
              currentTime: currentTime,
              isCompleted: isCompleted,
            ),
          )
          .toList(),
    );
  }

  List<ReminderModel> _sortReminders(List<ReminderModel> reminders) {
    return List<ReminderModel>.from(reminders)
      ..sort((a, b) {
        const priorityOrder = {
          'high': 2,
          'medium': 1,
          'low': 0,
        };

        final priorityA = priorityOrder[a.priority.toLowerCase()] ?? 0;
        final priorityB = priorityOrder[b.priority.toLowerCase()] ?? 0;

        if (priorityA != priorityB) {
          return priorityB.compareTo(priorityA);
        }

        return a.expiryDate.compareTo(b.expiryDate);
      });
  }
}
