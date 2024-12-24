const {
  priorityEnum,
  repeatIntervalEnum,
  repeatDaysEnum,
} = require("../constants/reminderConstants");

exports.isValidPriority = (input) => {
  return priorityEnum.includes(input);
};

exports.isValidRepeatInterval = (input) => {
  return repeatIntervalEnum.includes(input);
};

exports.isValidRepeatDay = (input) => {
  return repeatDaysEnum.includes(input);
};
