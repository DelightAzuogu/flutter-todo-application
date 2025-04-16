import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/home/home.dart';
import 'package:todo_application/shared/helpers/helpers.dart';

class ReminderDetails extends ConsumerStatefulWidget {
  const ReminderDetails({
    super.key,
    required this.id,
  });

  final String id;
  @override
  ConsumerState createState() => _ReminderDetailsState();
}

class _ReminderDetailsState extends ConsumerState<ReminderDetails> {
  @override
  Widget build(BuildContext context) {
    ref.invalidate(getAllLabelsProvider);

    ref.listen(reminderControllerProvider, (_, next) async {
      if (next.exception != null) {
        showCustomToast(message: 'An error has occurred');
        return;
      }

      if (next.isCompleted) {
        ref.invalidate(getUserReminderByDateProvider);
      } else if (next.isUpdated) {
        ref.invalidate(getReminderByIdProvider(widget.id));
        ref.invalidate(getUserReminderByDateProvider);
      } else if (next.isDeleted) {
        ref.invalidate(getUserReminderByDateProvider);
      }

      context.pop();
    });

    // Add labelControllerProvider listener
    ref.listen(labelControllerProvider, (previous, next) {
      if (next.isCreated) {
        ref.invalidate(getAllLabelsProvider);
        context.pop();
      }
    });

    final reminderAsyncValue = ref.watch(getReminderByIdProvider(widget.id));
    final labelAsyncValue = ref.watch(getAllLabelsProvider);
    final formGroup = ref.read(reminderControllerProvider.notifier).formGroup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(reminderControllerProvider.notifier).deleteReminder(widget.id);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(getReminderByIdProvider(widget.id));
          return Future.value();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: reminderAsyncValue.when(
            data: (reminder) {
              // Set initial values
              formGroup.control('title').value = reminder.title;
              formGroup.control('description').value = reminder.description;
              formGroup.control('expiryDate').value = reminder.expiryDate;
              formGroup.control('priority').value = reminder.priority;
              formGroup.control('repeatInterval').value = reminder.repeatInterval;
              formGroup.control('repeatEndDate').value = reminder.repeatEndDate;
              formGroup.control('repeatDays').value = reminder.repeatDays;
              formGroup.control('labelId').value = reminder.label?.id;

              return ReactiveForm(
                formGroup: formGroup,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReactiveTextField(
                        formControlName: 'title',
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(15),
                      ReactiveTextField(
                        formControlName: 'description',
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      const Gap(15),
                      ReactiveDateTimePicker(
                        formControlName: 'expiryDate',
                        datePickerEntryMode: DatePickerEntryMode.calendarOnly,
                        type: ReactiveDatePickerFieldType.dateTime,
                        confirmText: 'Ok',
                        cancelText: 'Cancel',
                        decoration: InputDecoration(
                          labelText: 'Due Date & Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
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
                                        ...labels.map(
                                          (label) => DropdownMenuItem(
                                            value: label.id,
                                            child: Text(label.name),
                                          ),
                                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: ReminderConstants.priorities
                            .map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.toUpperCase()),
                              ),
                            )
                            .toList(),
                      ),
                      const Gap(15),
                      ReactiveDropdownField<String>(
                        formControlName: 'repeatInterval',
                        decoration: const InputDecoration(
                          labelText: 'Repeat',
                          border: OutlineInputBorder(),
                        ),
                        items: ReminderConstants.repeatIntervals
                            .map(
                              (interval) => DropdownMenuItem(
                                value: interval,
                                child: Text(interval.toUpperCase()),
                              ),
                            )
                            .toList(),
                      ),
                      const Gap(15),
                      ReactiveValueListenableBuilder<String>(
                        formControl: formGroup.control('repeatInterval') as FormControl<String>,
                        builder: (context, control, child) {
                          if (control.value == 'custom') {
                            return Column(
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
                        formControl: formGroup.control('repeatInterval') as FormControl<String>,
                        builder: (context, control, child) {
                          if (control.value != 'none') {
                            return Column(
                              children: [
                                ReactiveDateTimePicker(
                                  formControlName: 'repeatEndDate',
                                  datePickerEntryMode: DatePickerEntryMode.calendarOnly,
                                  type: ReactiveDatePickerFieldType.date,
                                  confirmText: 'Ok',
                                  cancelText: 'Cancel',
                                  decoration: InputDecoration(
                                    labelText: 'Repeat End Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    suffixIcon: const Icon(Icons.calendar_today),
                                  ),
                                ),
                                const Gap(15),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ReactiveFormConsumer(
                              builder: (context, formGroup, child) {
                                return ElevatedButton(
                                  onPressed: formGroup.valid
                                      ? () async {
                                          final labelId = ref
                                              .read(reminderControllerProvider.notifier)
                                              .formGroup
                                              .control('labelId')
                                              .value as String?;
                                          await ref
                                              .read(labelControllerProvider.notifier)
                                              .assignLabelToReminder(labelId, widget.id);

                                          await ref.read(reminderControllerProvider.notifier).editReminder(reminder.id);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  child: const Text('Edit'),
                                );
                              },
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await ref.read(reminderControllerProvider.notifier).completeReminder(reminder.id);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Complete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (e, st) => const Center(child: Text('Error Occurred')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
