import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:todo_application/home/home.dart';
import 'package:todo_application/shared/helpers/helpers.dart';

class ViewRemindersByLabel extends ConsumerStatefulWidget {
  const ViewRemindersByLabel({super.key});

  @override
  ConsumerState createState() => _ViewRemindersByLabelState();
}

class _ViewRemindersByLabelState extends ConsumerState<ViewRemindersByLabel> {
  String _reminderFilter = 'pending'; // 'pending' or 'completed'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedLabelIdProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(labelControllerProvider, (prev, next) {
      if (next.exception != null) {
        showCustomToast(message: 'An Error has occurred');
        return;
      }

      if (next.isDeleted) {
        ref.read(selectedLabelIdProvider.notifier).state = null;
        ref.invalidate(getAllLabelsProvider);
        ref.invalidate(getRemindersByLabelProvider);
        ref.invalidate(getAllUserPendingRemindersProvider);
        ref.invalidate(getUserCompletedReminderByDateProvider);
        ref.invalidate(getUserReminderByDateProvider);
      }
    });

    final labelAsyncValue = ref.watch(getAllLabelsProvider);
    final selectedLabelId = ref.watch(selectedLabelIdProvider);
    final labelReminders = ref.watch(getRemindersByLabelProvider(labelId: selectedLabelId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders by Label'),
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          ref.invalidate(getAllLabelsProvider);
          ref.invalidate(getRemindersByLabelProvider);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dropdown
              labelAsyncValue.when(
                data: (labels) {
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          hint: const Text('Select Label (Optional)'),
                          value: selectedLabelId,
                          items: [
                            const DropdownMenuItem<String?>(value: null, child: Text('No Label')),
                            ...labels.map((label) => DropdownMenuItem(
                                  value: label.id,
                                  child: Text(label.name),
                                )),
                          ],
                          onChanged: (String? newValue) {
                            ref.read(selectedLabelIdProvider.notifier).state = newValue;
                          },
                          decoration: InputDecoration(
                            labelText: 'Label',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      const Gap(3),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever_outlined),
                          onPressed: selectedLabelId != null
                              ? () {
                                  ref.read(labelControllerProvider.notifier).deleteLabel(selectedLabelId);
                                }
                              : null,
                          tooltip: 'Delete Label',
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading labels: $error'),
              ),
              const Gap(16),

              // Filter chips
              Row(
                children: [
                  FilterChip(
                    label: const Text('Pending'),
                    selected: _reminderFilter == 'pending',
                    onSelected: (_) => setState(() => _reminderFilter = 'pending'),
                  ),
                  const Gap(8),
                  FilterChip(
                    label: const Text('Completed'),
                    selected: _reminderFilter == 'completed',
                    onSelected: (_) => setState(() => _reminderFilter = 'completed'),
                  ),
                ],
              ),
              const Gap(16),

              // Reminders List
              Expanded(
                child: labelReminders.when(
                  data: (reminders) {
                    if (reminders.isEmpty) {
                      return const Center(child: Text('No reminders found'));
                    }

                    final currentTime = DateTime.now();
                    final filteredReminders = reminders
                        .where((r) =>
                            (_reminderFilter == 'pending' && !r.isCompleted) ||
                            (_reminderFilter == 'completed' && r.isCompleted))
                        .toList()
                      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

                    if (filteredReminders.isEmpty) {
                      return Center(
                        child: Text('No $_reminderFilter reminders'),
                      );
                    }

                    return ListView(
                      children: filteredReminders
                          .map((reminder) => ReminderCard(
                                reminder: reminder,
                                currentTime: currentTime,
                                showLabel: false,
                              ))
                          .toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error loading reminders: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
