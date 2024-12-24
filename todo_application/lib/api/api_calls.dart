import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:todo_application/api/api.dart';
import 'package:todo_application/authentication/authentication.dart';
import 'package:todo_application/helpers/helpers.dart';

class ApiCalls {
  final FlutterSecureStorage secureStorage;

  ApiCalls({
    required this.secureStorage,
  });

  Future<User> loginUser(String email, String password) async {
    try {
      final url = Uri.parse(ApiCallsConstants.loginEndpoint);

      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromMap(userJson);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> registerUser(String email, String password, String name) async {
    try {
      final url = Uri.parse(ApiCallsConstants.registerEndpoint);

      final body = jsonEncode({'email': email, 'password': password, 'name': name});

      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {
        final userJson = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromMap(userJson);
      } else {
        throw Exception('signup failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // getting reminders by date
  Future<List<ReminderModel>> getRemindersByDate(DateTime date) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.getReminderByDateEndpoint}?date=${date.toIso8601String()}');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseList = jsonDecode(response.body) as List;
        return responseList
            .map(
              (element) => ReminderModel.fromMap(element),
            )
            .toList();
      } else {
        throw Exception('failed to get reminders for date $date with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // getting completed reminders by date
  Future<List<ReminderModel>> getCompletedRemindersByDate(DateTime date) async {
    try {
      final utcDate = DateFormatHelper.convertToUtc(date);
      final url = Uri.parse('${ApiCallsConstants.getCompletedRemindersEndpoint}?date=${utcDate.toIso8601String()}');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseList = jsonDecode(response.body) as List;
        return responseList
            .map(
              (element) => ReminderModel.fromMap(element),
            )
            .toList();
      } else {
        throw Exception('failed to get reminders for date $date with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReminderModel>> getAllReminders() async {
    try {
      final url = Uri.parse(ApiCallsConstants.getAllRemindersEndpoint);

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseList = jsonDecode(response.body) as List;
        return responseList
            .map(
              (element) => ReminderModel.fromMap(element),
            )
            .toList();
      } else {
        throw Exception('failed to get reminders with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReminderModel> getReminder(String reminderId) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.getReminderByIdEndpoint}/$reminderId');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final reminderJson = jsonDecode(response.body) as Map<String, dynamic>;
        return ReminderModel.fromMap(reminderJson);
      } else {
        throw Exception('failed to get reminders with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeReminder(String reminderId) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.completeReminderEndpoint}/$reminderId');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('failed to complete reminder $reminderId with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReminderModel> createReminder({
    required String title,
    required DateTime expiryDate,
    required String description,
    required String priority,
    required String repeatInterval,
    required DateTime? repeatEndDate,
    List<String>? repeatDays,
  }) async {
    try {
      final url = Uri.parse(ApiCallsConstants.createReminderEndpoint);

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'title': title,
          'expiryDate': expiryDate.toIso8601String(),
          'description': description,
          'repeatInterval': repeatInterval,
          'priority': priority,
          'repeatEndDate': repeatEndDate?.toIso8601String(),
          'repeatDays': repeatDays,
        }),
      );

      if (response.statusCode == 201) {
        return ReminderModel.fromJson(response.body);
      } else {
        throw Exception('failed to create reminder with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateReminder({
    required String title,
    required DateTime expiryDate,
    required String reminderId,
    required String description,
    required String repeatInterval,
    required String priority,
    DateTime? repeatEndDate,
    List<String>? repeatDays,
  }) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.updateReminderEndpoint}/$reminderId');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'title': title,
          'expiryDate': expiryDate.toIso8601String(),
          'description': description,
          'repeatInterval': repeatInterval,
          'priority': priority,
          'repeatEndDate': repeatEndDate?.toIso8601String(),
          'repeatDays': repeatDays,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('failed to update reminder with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.deleteReminderEndpoint}/$reminderId');

      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('failed to delete reminder with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LabelModel>> getAllLabels() async {
    try {
      final url = Uri.parse(ApiCallsConstants.getAllLabelsEndpoint);
      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseList = jsonDecode(response.body) as List;
        return responseList
            .map(
              (element) => LabelModel.fromMap(element),
            )
            .toList();
      } else {
        throw Exception('failed to get user label: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createLabel(String name) async {
    try {
      final url = Uri.parse(ApiCallsConstants.createLabelEndpoint);
      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('failed to create label: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLabel(String labelId) async {
    try {
      final url = Uri.parse('${ApiCallsConstants.deleteLabelEndpoint}/$labelId');
      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('failed to delete label: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignLabelToReminder({
    required String? labelId,
    required String reminderId,
  }) async {
    try {
      final url = Uri.parse(ApiCallsConstants.assignLabelToReminderEndpoint);
      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'labelId': labelId,
          'reminderId': reminderId,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('failed to assign label to reminder: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReminderModel>> getRemindersByLabel({
    required String? labelId,
  }) async {
    try {
      if (labelId == null) {
        return [];
      }

      final url = Uri.parse('${ApiCallsConstants.geReminderByLabelIdEndpoint}/$labelId');
      final accessToken = await secureStorage.read(key: 'accessToken');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseList = jsonDecode(response.body) as List;
        return responseList
            .map(
              (element) => ReminderModel.fromMap(element),
            )
            .toList();
      } else {
        throw Exception('failed to assign label to reminder: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
