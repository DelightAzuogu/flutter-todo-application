import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/helpers/helpers.dart';
import 'package:todo_application/home/home.dart';

class ReminderCard extends ConsumerWidget {
  final ReminderModel reminder;
  final DateTime currentTime;
  final bool showLabel;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.currentTime,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverDue = reminder.expiryDate.isBefore(currentTime);
    final priorityColor = _getPriorityColor(reminder.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: reminder.isCompleted
              ? null
              : () {
                  ref.read(selectedReminderProvider.notifier).state = reminder;
                  context.pushNamed('reminderDetail', pathParameters: {'reminderId': reminder.id});
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showLabel && reminder.label != null) ...[
                  PriorityBadge(priority: reminder.label!.name, color: Theme.of(context).colorScheme.primary),
                  const Gap(8),
                ],
                Row(
                  children: [
                    if (!reminder.isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ReminderCheckbox(reminder: reminder),
                      ),
                    Expanded(
                      child: _buildReminderContent(context),
                    ),
                  ],
                ),
                const Gap(8),
                _buildReminderFooter(context, isOverDue, priorityColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reminder.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
              ),
        ),
        if (reminder.description != null) ...[
          const Gap(4),
          Text(
            reminder.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String _getRelativeDateText(DateTime date, DateTime currentTime) {
    final today = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final reminderDate = DateTime(date.year, date.month, date.day);

    if (reminderDate == today) {
      return 'Today at ${DateFormatHelper.formatTimeToString(date)}';
    } else if (reminderDate == tomorrow) {
      return 'Tomorrow at ${DateFormatHelper.formatTimeToString(date)}';
    } else if (reminderDate == yesterday) {
      return 'Yesterday at ${DateFormatHelper.formatTimeToString(date)}';
    } else {
      return DateFormatHelper.formatDateTimeToString(date);
    }
  }

  Widget _buildReminderFooter(BuildContext context, bool isOverDue, Color priorityColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const Gap(4),
                Text(
                  _getRelativeDateText(reminder.expiryDate, currentTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Column(
              children: [
                PriorityBadge(priority: reminder.priority, color: priorityColor),
                if (isOverDue && !reminder.isCompleted) ...[
                  const Gap(8),
                  const OverdueBadge(),
                ],
              ],
            ),
          ],
        ),
        if (reminder.repeatInterval != 'none') ...[
          const Gap(8),
          _buildRepeatInterval(context),
        ],
      ],
    );
  }

  Widget _buildRepeatInterval(BuildContext context) {
    final text = reminder.repeatInterval == 'custom'
        ? reminder.repeatDays
            .map(
              (days) => days.substring(
                0,
                3,
              ),
            )
            .join(", ")
        : ' Repeats ${reminder.repeatInterval}';
    return Row(
      children: [
        Icon(Icons.repeat, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const Gap(4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
