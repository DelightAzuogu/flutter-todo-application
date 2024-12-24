import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_application/authentication/authentication.dart';
import 'package:todo_application/home/home.dart';

class ViewPendingReminders extends ConsumerWidget {
  const ViewPendingReminders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      reminderControllerProvider,
      (prev, next) {
        if (next.isCompleted) {
          ref.invalidate(getUserReminderByDateProvider);
          ref.invalidate(getUserCompletedReminderByDateProvider);
          ref.invalidate(reminderControllerProvider);
        }
      },
    );

    final remindersAsyncValue = ref.watch(getAllUserPendingRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.invalidate(selectedDateProvider);
              ref.invalidate(getUserReminderByDateProvider);
              ref.invalidate(getUserCompletedReminderByDateProvider);
              ref.invalidate(getAllUserPendingRemindersProvider);
              ref.read(authenticationControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(getAllUserPendingRemindersProvider);
          return Future.value();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: remindersAsyncValue.when(
              data: (reminders) {
                if (reminders.isEmpty) {
                  return const Text('No pending reminders');
                }

                final currentTime = DateTime.now();

                final overDueReminders = reminders
                    .where((reminder) => reminder.expiryDate.isBefore(currentTime))
                    .toList()
                  ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

                final pendingReminders = reminders
                    .where((reminder) => reminder.expiryDate.isAfter(currentTime))
                    .toList()
                  ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (overDueReminders.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Overdue",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const Gap(16),
                      ReminderList(
                        reminders: overDueReminders,
                        currentTime: currentTime,
                        isCompleted: false,
                      ),
                    ],
                    if (pendingReminders.isNotEmpty) ...[
                      Text(
                        "Soon",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Gap(16),
                      ReminderList(
                        reminders: pendingReminders,
                        currentTime: currentTime,
                        isCompleted: false,
                      ),
                    ]
                  ],
                );
              },
              error: (_, __) => const Center(
                child: Text('Failed to load reminders'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('create'),
        icon: const Icon(Icons.add),
        label: const Text('New Reminder'),
      ),
    );
  }
}
