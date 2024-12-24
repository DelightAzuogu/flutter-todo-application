import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_application/api/api.dart';

part 'get_all_labels_provider.g.dart';

@riverpod
Future<List<LabelModel>> getAllLabels(GetAllLabelsRef ref) async {
  final apiCalls = ref.watch(apiCallProvider);

  return apiCalls.getAllLabels();
}
