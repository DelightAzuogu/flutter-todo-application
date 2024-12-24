import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/home/home.dart';

part 'get_user_reminder_by_date_provider.g.dart';

@riverpod
Future<List<ReminderModel>> getUserReminderByDate(GetUserReminderByDateRef ref) async {
  final apiCalls = ref.watch(apiCallProvider);

  final date = ref.watch(selectedDateProvider);

  return apiCalls.getRemindersByDate(date);
}

@riverpod
Future<List<ReminderModel>> getUserCompletedReminderByDate(GetUserReminderByDateRef ref) async {
  final apiCalls = ref.watch(apiCallProvider);

  final date = ref.watch(selectedDateProvider);

  return apiCalls.getCompletedRemindersByDate(date);
}
