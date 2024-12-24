import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'assign_label_to_reminder_provider.g.dart';

@riverpod
Future<void> assignLabelToReminder(
  AssignLabelToReminderRef ref, {
  required String labelId,
  required String reminderId,
}) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.assignLabelToReminder(reminderId: reminderId, labelId: labelId);
}
