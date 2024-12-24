import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_application/home/providers/selected_date_provider.dart';

class SelectDatePage extends ConsumerWidget {
  const SelectDatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Select a date'),
        ),
        body: Center(
          child: TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              ref.read(selectedDateProvider.notifier).state = date;
              context.pop();
            },
            focusedDay: selectedDate,
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 1000)),
            currentDay: selectedDate,
          ),
        ));
  }
}
