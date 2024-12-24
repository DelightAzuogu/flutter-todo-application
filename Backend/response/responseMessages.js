class ResponseMessage {
  static InvalidAuthToken = "INVALID_AUTH_TOKEN";
  static UserNotFound = "USER_NOT_FOUND";
  static UserWithEmailExists = "USER_WITH_EMAIL_EXISTS";
  static InvalidEmailOrPassword = "INVALID_EMAIL_OR_PASSWORD";
  static InvalidDate = "INVALID_DATE";
  static ReminderNotFound = "REMINDER_NOT_FOUND";
  static ReminderDoesNotBelongToUser =
    "REMINDER_DOES_NOT_BELONG_TO_USER";
  static ReminderDeleted = "REMINDER_DELETED";
  static InvalidRepeatDays = "INVALID_REPEAT_DAYS";
  static InvalidRepeatIntervals = "INVALID_REPEAT_INTERVALS";
  static invalidPriority = "INVALID_PRIORITY";
  static invalidEndDate = "INVALID_END_DATE";
}

exports.ResponseMessage = ResponseMessage;
