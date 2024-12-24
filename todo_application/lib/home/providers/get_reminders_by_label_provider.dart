import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'get_reminders_by_label_provider.g.dart';

@riverpod
Future<List<ReminderModel>> getRemindersByLabel(
  GetRemindersByLabelRef ref, {
  required String? labelId,
}) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.getRemindersByLabel(labelId: labelId);
}
