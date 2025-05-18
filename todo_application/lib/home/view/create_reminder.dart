import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/home/home.dart';
import 'package:todo_application/shared/helpers/helpers.dart';

class CreateReminder extends ConsumerStatefulWidget {
  const CreateReminder({super.key});

  @override
  ConsumerState createState() => _CreateReminderState();
}

class _CreateReminderState extends ConsumerState<CreateReminder> {
  late final FormGroup formGroup;
  @override
  void initState() {
    super.initState();

    final reminderNotifier = ref.read(reminderControllerProvider.notifier);

    formGroup = reminderNotifier.formGroup;
  }

  @override
  Widget build(BuildContext context) {
    ref.invalidate(getAllLabelsProvider);

    // reminder controller provider listener
    ref.listen(
      reminderControllerProvider,
      (prev, next) async {
        if (next.exception != null) {
          showCustomToast(message: 'An error occurred while creating your reminder');
        }

        if (next.isCreated) {
          final labelId = ref.read(reminderControllerProvider.notifier).formGroup.control('labelId').value as String?;
          if (labelId != null) {
            await ref.read(labelControllerProvider.notifier).assignLabelToReminder(labelId, next.reminderId!);
          }

          context.goNamed('home');

          final reminderNotifier = ref.read(reminderControllerProvider.notifier);
          reminderNotifier.clearForm();

          ref.invalidate(getUserReminderByDateProvider);
        }
      },
    );

    // labelControllerProvider listener
    ref.listen(labelControllerProvider, (previous, next) {
      if (next.isCreated) {
        ref.invalidate(getAllLabelsProvider);
        context.pop();
      }
    });

    final labelAsyncValue = ref.watch(getAllLabelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: formGroup,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReactiveTextField(
                formControlName: 'title',
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validationMessages: {
                  'required': (error) => 'Title is required',
                },
              ),
              const Gap(15),
              ReactiveTextField(
                formControlName: 'description',
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 10,
              ),
              const Gap(15),
              ReactiveDateTimePicker(
                formControlName: 'expiryDate',
                datePickerEntryMode: DatePickerEntryMode.calendarOnly,
                type: ReactiveDatePickerFieldType.dateTime,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                confirmText: 'Ok',
                cancelText: 'Cancel',
                decoration: InputDecoration(
                  labelText: 'Reminder Date & Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validationMessages: {
                  'required': (error) => 'Date and time are required',
                },
              ),
              const Gap(15),
              labelAsyncValue.when(
                data: (labels) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ReactiveDropdownField<String?>(
                              formControlName: 'labelId',
                              hint: const Text('Select Label (Optional)'),
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('No Label'),
                                ),
                                ...labels
                                    .map(
                                      (label) => DropdownMenuItem(
                                        value: label.id,
                                        child: Text(label.name),
                                      ),
                                    )
                                    .toList(),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Label',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const CreateLabelDialog(),
                              );
                            },
                            tooltip: 'Create New Label',
                          ),
                        ],
                      ),
                      const Gap(15),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading labels: $error'),
              ),
              const Gap(15),
              ReactiveDropdownField<String>(
                formControlName: 'priority',
                items: ReminderConstants.priorities
                    .map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toUpperCase()),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validationMessages: {
                  'required': (error) => 'Priority is required',
                },
              ),
              const Gap(15),
              ReactiveDropdownField<String>(
                formControlName: 'repeatInterval',
                items: ReminderConstants.repeatIntervals
                    .map(
                      (interval) => DropdownMenuItem(
                        value: interval,
                        child: Text(interval.toUpperCase()),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Repeat Interval',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validationMessages: {
                  'required': (error) => 'Repeat interval is required',
                },
              ),
              const Gap(15),
              ReactiveValueListenableBuilder<String>(
                formControlName: 'repeatInterval',
                builder: (context, control, child) {
                  if (control.value == 'custom') {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeekdaySelector(
                          control: formGroup.control('repeatDays') as FormControl<List<String>>,
                        ),
                        const Gap(15),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              ReactiveValueListenableBuilder<String>(
                formControlName: 'repeatInterval',
                builder: (context, control, child) {
                  if (control.value != 'none') {
                    return Column(
                      children: [
                        ReactiveDateTimePicker(
                          formControlName: 'repeatEndDate',
                          datePickerEntryMode: DatePickerEntryMode.calendarOnly,
                          type: ReactiveDatePickerFieldType.date,
                          firstDate: DateTime.now(),
                          confirmText: 'Ok',
                          cancelText: 'Cancel',
                          decoration: InputDecoration(
                            labelText: 'Repeat Until',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          validationMessages: {
                            'required': (error) => 'End date is required for recurring reminders',
                          },
                        ),
                        const Gap(15),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const Gap(30),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: form.valid
                          ? () async {
                              await ref.read(reminderControllerProvider.notifier).createReminder();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Create Reminder',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
