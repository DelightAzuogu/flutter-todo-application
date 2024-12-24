import 'dart:convert';

import 'package:equatable/equatable.dart';

class LabelModel extends Equatable {
  final String id;
  final String name;

  const LabelModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
    ];
  }

  factory LabelModel.fromMap(Map<String, dynamic> map) {
    return LabelModel(
      id: map['id'],
      name: map['name'],
    );
  }

  factory LabelModel.fromJson(String source) => LabelModel.fromMap(json.decode(source));
}
