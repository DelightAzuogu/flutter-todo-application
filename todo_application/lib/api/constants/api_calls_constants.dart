class ApiCallsConstants {
  ApiCallsConstants._();

  static const String _baseUrl = 'https://dlln3t6z-3000.euw.devtunnels.ms';
  static const String loginEndpoint = '$_baseUrl/auth/login';
  static const String getReminderByDateEndpoint = '$_baseUrl/reminder/user/all/date';
  static const String getCompletedRemindersEndpoint = '$_baseUrl/reminder/user/all/date/completed';
  static const String completeReminderEndpoint = '$_baseUrl/reminder/complete';
  static const String createReminderEndpoint = '$_baseUrl/reminder/create';
  static const String registerEndpoint = '$_baseUrl/auth/signup';
  static const String getAllRemindersEndpoint = '$_baseUrl/reminder/user/all';
  static const String getReminderByIdEndpoint = '$_baseUrl/reminder';
  static const String updateReminderEndpoint = '$_baseUrl/reminder/update';
  static const String deleteReminderEndpoint = '$_baseUrl/reminder/delete';
  static const String assignLabelToReminderEndpoint = '$_baseUrl/reminder/assign-label';
  static const String geReminderByLabelIdEndpoint = '$_baseUrl/reminder/label';

  static String getAllLabelsEndpoint = '$_baseUrl/label/user/all';
  static String createLabelEndpoint = '$_baseUrl/label/create';
  static String deleteLabelEndpoint = '$_baseUrl/label/delete';
}
