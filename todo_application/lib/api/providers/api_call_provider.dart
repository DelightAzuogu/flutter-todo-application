import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/storage/storage_provider.dart';

final apiCallProvider = Provider<ApiCalls>((ref) {
  final secureStorage = ref.watch(storageProvider);

  final apiCalls = ApiCalls(secureStorage: secureStorage);

  return apiCalls;
});
