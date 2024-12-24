import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'get_reminder_by_id_provider.g.dart';

@riverpod
Future<ReminderModel> getReminderById(GetReminderByIdRef ref, String reminderId) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.getReminder(reminderId);
}
