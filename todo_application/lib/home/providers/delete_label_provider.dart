import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'delete_label_provider.g.dart';

@riverpod
Future<void> deleteLabel(
  DeleteLabelRef ref, {
  required String labelId,
}) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.deleteLabel(labelId);
}
