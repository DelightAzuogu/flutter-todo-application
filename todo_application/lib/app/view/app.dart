import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/app/app.dart';

class App extends ConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final router = ref.watch(appRouterProvider).router;

    return MaterialApp.router(
      // useInheritedMediaQuery: true,
      routerConfig: router,
      title: 'Todo Application',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
