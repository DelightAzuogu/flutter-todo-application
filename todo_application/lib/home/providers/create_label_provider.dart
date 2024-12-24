import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'create_label_provider.g.dart';

@riverpod
Future<void> createLabel(
  CreateLabelRef ref, {
  required String labelName,
}) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.createLabel(labelName);
}
