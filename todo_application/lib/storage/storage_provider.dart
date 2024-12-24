import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storageProvider = StateProvider<FlutterSecureStorage>((ref) {
  const AndroidOptions androidOptions = AndroidOptions(encryptedSharedPreferences: true);

  return const FlutterSecureStorage(aOptions: androidOptions);
});

final tokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(storageProvider);
  return await storage.read(key: 'token');
});

final userNameProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(storageProvider);
  return await storage.read(key: 'name');
});

final userEmailProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(storageProvider);
  return await storage.read(key: 'email');
});

final userIdProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(storageProvider);
  return await storage.read(key: 'id');
});
