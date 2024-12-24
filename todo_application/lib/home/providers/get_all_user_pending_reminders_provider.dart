import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'get_all_user_pending_reminders_provider.g.dart';

@riverpod
Future<List<ReminderModel>> getAllUserPendingReminders(GetAllUserPendingRemindersRef ref) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.getAllReminders();
}
