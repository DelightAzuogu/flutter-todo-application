import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:todo_application/api/api.dart';

class ReminderModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String status;
  final DateTime expiryDate;
  final String priority;
  final String repeatInterval;
  final DateTime? repeatEndDate;
  final List<String> repeatDays;
  final LabelModel? label;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.expiryDate,
    required this.priority,
    required this.repeatInterval,
    this.repeatEndDate,
    required this.repeatDays,
    this.label,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      status,
      expiryDate,
      priority,
      repeatInterval,
      repeatEndDate,
      repeatDays,
      label,
    ];
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    final expiryDateString = map['expiryDate'] as String;
    final repeatEndDateString = map['repeatEndDate'] as String?;

    final expiryDate = DateTime.parse(expiryDateString).toLocal();
    final repeatEndDate = repeatEndDateString != null ? DateTime.parse(repeatEndDateString).toLocal() : null;

    return ReminderModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      expiryDate: expiryDate,
      priority: map['priority'],
      repeatInterval: map['repeatInterval'],
      repeatEndDate: repeatEndDate,
      repeatDays: List<String>.from(map['repeatDays'] ?? []),
      label: map['label'] != null ? LabelModel.fromMap(map['label']) : null,
    );
  }

  factory ReminderModel.fromJson(String source) => ReminderModel.fromMap(json.decode(source));
}
