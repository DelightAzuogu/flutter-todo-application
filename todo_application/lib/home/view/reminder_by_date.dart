import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_application/authentication/authentication.dart';
import 'package:todo_application/home/home.dart';
import 'package:todo_application/shared/helpers/helpers.dart';

class RemindersByDate extends ConsumerStatefulWidget {
  const RemindersByDate({super.key});

  @override
  ConsumerState createState() => _ReminderByDateState();
}

class _ReminderByDateState extends ConsumerState<RemindersByDate> {
  @override
  Widget build(BuildContext context) {
    ref.listen(
      reminderControllerProvider,
      (prev, next) {
        if (next.exception != null) {
          showCustomToast(message: 'An Error has occurred');
          return;
        }

        if (next.isCompleted) {
          ref.invalidate(getUserReminderByDateProvider);
          ref.invalidate(getUserCompletedReminderByDateProvider);
          ref.invalidate(reminderControllerProvider);
        }
      },
    );

    final selectedDate = ref.watch(selectedDateProvider.notifier).state;
    final remindersAsyncValue = ref.watch(getUserReminderByDateProvider);
    final completedRemindersAsyncValue = ref.watch(getUserCompletedReminderByDateProvider);
    final currentTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.invalidate(selectedDateProvider);
              ref.invalidate(getUserReminderByDateProvider);
              ref.invalidate(getUserCompletedReminderByDateProvider);
              ref.read(authenticationControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(getUserReminderByDateProvider);
          ref.invalidate(getUserCompletedReminderByDateProvider);
          ref.invalidate(reminderControllerProvider);
          return Future.value();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                DateHeader(selectedDate: selectedDate),
                const Gap(20),
                remindersAsyncValue.when(
                  data: (reminders) {
                    return ReminderList(
                      reminders: reminders,
                      currentTime: currentTime,
                      isCompleted: false,
                    );
                  },
                  error: (_, __) => const Center(
                    child: Text('Failed to load reminders'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const Gap(30),
                CompletedSection(
                  completedRemindersAsyncValue: completedRemindersAsyncValue,
                  currentTime: currentTime,
                ),
              ],
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
