import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/helpers/helpers.dart';
import 'package:todo_application/home/providers/reminder_controller_state.dart';

final reminderControllerProvider = StateNotifierProvider<ReminderController, ReminderControllerState>((ref) {
  final apiCalls = ref.watch(apiCallProvider);
  return ReminderController(apiCalls: apiCalls);
});

class ReminderController extends StateNotifier<ReminderControllerState> {
  final ApiCalls apiCalls;
  late final FormGroup formGroup;

  ReminderController({
    required this.apiCalls,
  }) : super(const ReminderControllerState()) {
    formGroup = FormGroup(
      {
        'title': FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
        'description': FormControl<String>(),
        'expiryDate': FormControl<DateTime>(
          validators: [
            Validators.required,
          ],
        ),
        'priority': FormControl<String>(
          value: 'medium',
          validators: [
            Validators.required,
          ],
        ),
        'repeatInterval': FormControl<String>(
          value: 'none',
          validators: [
            Validators.required,
          ],
        ),
        'repeatEndDate': FormControl<DateTime>(),
        'repeatDays': FormControl<List<String>>(
          value: [],
        ),
        'labelId': FormControl<String?>(
          // No validators, making it optional
          value: null,
        ),
      },
    );

    // Add validation listener for repeatInterval
    formGroup.control('repeatInterval').valueChanges.listen((value) {
      if (value == 'custom') {
        formGroup.control('repeatDays')
          ..setValidators([
            Validators.required,
            Validators.minLength(1),
          ])
          ..updateValueAndValidity();
      } else {
        formGroup.control('repeatDays')
          ..setValidators([])
          ..updateValueAndValidity();
      }

      if (value != 'none') {
        formGroup.control('repeatEndDate')
          ..setValidators([
            Validators.required,
          ])
          ..updateValueAndValidity();
      } else {
        formGroup.control('repeatEndDate')
          ..setValidators([])
          ..updateValueAndValidity();
      }
    });
  }

  void clearForm() {
    // Reset each control to its initial state
    formGroup.control('title').reset();
    formGroup.control('description').reset();
    formGroup.control('expiryDate').reset();
    formGroup.control('priority').reset(value: 'medium');
    formGroup.control('repeatInterval').reset(value: 'none');
    formGroup.control('repeatEndDate').reset();
    formGroup.control('repeatDays').reset(value: <String>[]);
    formGroup.control('labelId').reset(value: null);

    // Reset the form's validation state
    formGroup.markAsUntouched();
    formGroup.markAsPristine();

    // Reset the controller state
    state = const ReminderControllerState();
  }

  Future<void> completeReminder(String reminderId) async {
    try {
      await apiCalls.completeReminder(reminderId);
      state = const ReminderControllerState(isCompleted: true);
    } on Exception catch (e, st) {
      state = ReminderControllerState(
        exception: e,
        stackTrace: st,
        isCompleted: false,
      );
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await apiCalls.deleteReminder(reminderId);
      state = const ReminderControllerState(isDeleted: true);
    } on Exception catch (e, st) {
      state = ReminderControllerState(
        exception: e,
        stackTrace: st,
        isDeleted: false,
      );
    }
  }

  Future<void> createReminder() async {
    try {
      final repeatInterval = formGroup.control('repeatInterval').value as String;
      final List<String>? repeatDays =
          repeatInterval == 'custom' ? formGroup.control('repeatDays').value as List<String> : null;

      // Convert local dates to UTC
      final expiryDate = DateFormatHelper.convertToUtc(formGroup.control('expiryDate').value as DateTime);
      final repeatEndDate = repeatInterval != 'none'
          ? DateFormatHelper.convertToUtc(formGroup.control('repeatEndDate').value as DateTime)
          : null;

      final title = formGroup.control('title').value as String;
      final description = formGroup.control('description').value as String?;
      final priority = formGroup.control('priority').value as String;

      final reminder = await apiCalls.createReminder(
        title: title,
        description: description ?? '',
        expiryDate: expiryDate,
        priority: priority,
        repeatInterval: repeatInterval,
        repeatEndDate: repeatEndDate,
        repeatDays: repeatDays,
      );

      state = ReminderControllerState(
        isCreated: true,
        reminderId: reminder.id,
      );
    } on Exception catch (e, st) {
      state = ReminderControllerState(
        exception: e,
        stackTrace: st,
      );
    }
  }

  Future<void> editReminder(String id) async {
    try {
      final repeatInterval = formGroup.control('repeatInterval').value as String;
      final List<String>? repeatDays =
          repeatInterval == 'custom' ? formGroup.control('repeatDays').value as List<String> : null;

      // Convert local dates to UTC
      final expiryDate = DateFormatHelper.convertToUtc(formGroup.control('expiryDate').value as DateTime);
      final repeatEndDate = repeatInterval != 'none'
          ? DateFormatHelper.convertToUtc(formGroup.control('repeatEndDate').value as DateTime)
          : null;

      await apiCalls.updateReminder(
        title: formGroup.control('title').value,
        expiryDate: expiryDate,
        reminderId: id,
        description: formGroup.control('description').value,
        priority: formGroup.control('priority').value,
        repeatInterval: repeatInterval,
        repeatEndDate: repeatEndDate,
        repeatDays: repeatDays,
      );

      state = ReminderControllerState(
        isUpdated: true,
        reminderId: id,
      );
    } on Exception catch (e, st) {
      state = ReminderControllerState(
        isUpdated: false,
        exception: e,
        stackTrace: st,
      );
    }
  }
}
