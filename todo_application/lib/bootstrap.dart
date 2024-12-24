import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder].
// ignore: long-method
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Set allowed Orientations
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ProviderScope(
      child: await builder(),
    ),
  );
}
