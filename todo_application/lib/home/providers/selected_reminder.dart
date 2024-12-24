import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/api/api.dart';

final selectedReminderProvider = StateProvider<ReminderModel?>((ref) => null);
