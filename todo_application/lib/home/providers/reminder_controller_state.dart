import 'package:equatable/equatable.dart';

class ReminderControllerState extends Equatable {
  const ReminderControllerState({
    this.isCreated = false,
    this.isUpdated = false,
    this.isDeleted = false,
    this.isCompleted = false,
    this.exception,
    this.stackTrace,
    this.reminderId,
  });

  final bool isCreated;
  final bool isUpdated;
  final bool isDeleted;
  final bool isCompleted;
  final Exception? exception;
  final StackTrace? stackTrace;
  final String? reminderId;

  @override
  List<Object?> get props => [
        isCompleted,
        isCreated,
        isDeleted,
        isUpdated,
        exception,
        stackTrace,
        reminderId,
      ];

  ReminderControllerState copyWith({
    String? userId,
    Exception? exception,
    StackTrace? stackTrace,
    bool? isCreated,
    bool? isUpdated,
    bool? isDeleted,
    bool? isCompleted,
    String? reminderId,
  }) {
    return ReminderControllerState(
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? this.stackTrace,
      isCompleted: isCompleted ?? this.isCompleted,
      isCreated: isCreated ?? this.isCreated,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
      reminderId: reminderId ?? this.reminderId,
    );
  }
}
