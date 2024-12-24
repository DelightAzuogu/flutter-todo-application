exports.reminderStatusObject = {
  pending: "pending",
  complete: "completed",
};

exports.reminderStatusArray = [
  this.reminderStatusObject.pending,
  this.reminderStatusObject.complete,
];

exports.priorityEnumObject = {
  low: "low",
  medium: "medium",
  high: "high",
};

exports.priorityEnum = [
  this.priorityEnumObject.low,
  this.priorityEnumObject.medium,
  this.priorityEnumObject.high,
];

exports.repeatIntervalEnumObject = {
  daily: "daily",
  weekly: "weekly",
  monthly: "monthly",
  yearly: "yearly",
  custom: "custom",
  none: "none",
};

exports.repeatIntervalEnum = [
  this.repeatIntervalEnumObject.daily,
  this.repeatIntervalEnumObject.weekly,
  this.repeatIntervalEnumObject.monthly,
  this.repeatIntervalEnumObject.yearly,
  this.repeatIntervalEnumObject.custom,
  this.repeatIntervalEnumObject.none,
];

exports.repeatDaysEnumObject = {
  Sunday: "Sunday",
  Monday: "Monday",
  Tuesday: "Tuesday",
  Wednesday: "Wednesday",
  Thursday: "Thursday",
  Friday: "Friday",
  Saturday: "Saturday",
};

exports.repeatDaysEnum = [
  this.repeatDaysEnumObject.Sunday,
  this.repeatDaysEnumObject.Monday,
  this.repeatDaysEnumObject.Tuesday,
  this.repeatDaysEnumObject.Wednesday,
  this.repeatDaysEnumObject.Thursday,
  this.repeatDaysEnumObject.Friday,
  this.repeatDaysEnumObject.Saturday,
];
