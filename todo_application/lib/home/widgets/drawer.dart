import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
              ),
              child: Center(
                child: Text(
                  'My Reminders',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                children: [
                  DrawerItem(
                    title: 'Reminder By Date',
                    onTap: () {
                      context.pushNamed("home");
                    },
                  ),
                  DrawerItem(
                    title: 'Reminder By Label',
                    onTap: () {
                      context.pushNamed('viewReminderByLabel');
                    },
                  ),
                  DrawerItem(
                    title: 'View Pending',
                    onTap: () {
                      context.pushNamed('viewAllPending');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerItem({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blueGrey[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
      ),
    );
  }
}
