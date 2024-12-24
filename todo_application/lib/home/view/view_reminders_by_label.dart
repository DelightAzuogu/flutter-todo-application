import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:todo_application/home/home.dart';

class ViewRemindersByLabel extends ConsumerStatefulWidget {
  const ViewRemindersByLabel({super.key});

  @override
  ConsumerState createState() => _ViewRemindersByLabelState();
}

class _ViewRemindersByLabelState extends ConsumerState<ViewRemindersByLabel> {
  @override
  Widget build(BuildContext context) {
    ref.listen(labelControllerProvider, (prev, next) {
      if (next.isDeleted) {
        ref.read(selectedLabelIdProvider.notifier).state = null;
        ref.invalidate(getAllLabelsProvider);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                labelAsyncValue.when(
                  data: (labels) {
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            hint: const Text('Select Label (Optional)'),
                            value: selectedLabelId,
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
                labelReminders.when(
                  data: (reminders) {
                    if (reminders.isEmpty) {
                      return const Center(
                        child: Text('No reminders found'),
                      );
                    }
                    final currentTime = DateTime.now();

                    return Expanded(
                      child: ListView(
                        children: reminders
                            .map(
                              (reminder) => ReminderCard(
                                reminder: reminder,
                                currentTime: currentTime,
                                isCompleted: reminder.expiryDate.isBefore(currentTime),
                                showLabel: false,
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error loading reminders: $error'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
