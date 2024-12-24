import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String accessToken;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      accessToken,
    ];
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      accessToken: map['accessToken'],
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
