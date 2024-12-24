import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_application/api/api.dart';

// State class for LabelController
class LabelControllerState {
  final bool isCreated;
  final bool isAssigned;
  final bool isDeleted;
  final Exception? exception;
  final StackTrace? stackTrace;

  const LabelControllerState({
    this.isCreated = false,
    this.exception,
    this.stackTrace,
    this.isAssigned = false,
    this.isDeleted = false,
  });
}

// Provider for LabelController
final labelControllerProvider = StateNotifierProvider<LabelController, LabelControllerState>((ref) {
  final apiCalls = ref.watch(apiCallProvider);
  return LabelController(apiCalls: apiCalls);
});

class LabelController extends StateNotifier<LabelControllerState> {
  final ApiCalls apiCalls;

  LabelController({required this.apiCalls}) : super(const LabelControllerState());

  Future<void> createLabel(String name) async {
    try {
      await apiCalls.createLabel(name);
      state = const LabelControllerState(isCreated: true);
    } on Exception catch (e, st) {
      state = LabelControllerState(
        exception: e,
        stackTrace: st,
      );
    }
  }

  Future<void> assignLabelToReminder(String? labelId, String reminderId) async {
    try {
      await apiCalls.assignLabelToReminder(reminderId: reminderId, labelId: labelId);
      state = const LabelControllerState(isAssigned: true);
    } on Exception catch (e, st) {
      state = LabelControllerState(
        exception: e,
        stackTrace: st,
      );
    }
  }

  Future<void> deleteLabel(String labelId) async {
    try {
      await apiCalls.deleteLabel(labelId);
      state = const LabelControllerState(isDeleted: true);
    } on Exception catch (e, st) {
      state = LabelControllerState(
        exception: e,
        stackTrace: st,
      );
    }
  }
}
