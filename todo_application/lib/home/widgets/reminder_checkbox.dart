import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/home/home.dart';

class ReminderCheckbox extends ConsumerWidget {
  final ReminderModel reminder;

  const ReminderCheckbox({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          final reminderController = ref.read(reminderControllerProvider.notifier);
          await reminderController.completeReminder(reminder.id);
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
