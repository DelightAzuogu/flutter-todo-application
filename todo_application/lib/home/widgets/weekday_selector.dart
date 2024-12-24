import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/home/home.dart';

class WeekdaySelector extends StatelessWidget {
  final FormControl<List<String>> control;

  const WeekdaySelector({
    super.key,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repeat Days',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ReminderConstants.weekDays.map(
              (day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ReactiveValueListenableBuilder<List<String>>(
                    formControl: control,
                    builder: (context, control, _) {
                      final isSelected = (control.value ?? []).contains(day);

                      return InkWell(
                        onTap: () {
                          final currentValue = List<String>.from(control.value ?? []);
                          if (isSelected) {
                            currentValue.remove(day);
                          } else {
                            currentValue.add(day);
                          }
                          // Sort the days according to weekDays order
                          control.value = currentValue;
                          currentValue.sort(
                            (a, b) => ReminderConstants.weekDays.indexOf(a).compareTo(
                                  ReminderConstants.weekDays.indexOf(b),
                                ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            day.substring(0, 3),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ).toList(),
          ),
        ),
        ReactiveValueListenableBuilder<List<String>>(
          formControl: control,
          builder: (context, control, _) {
            if (control.hasErrors) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "select at least one day",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
