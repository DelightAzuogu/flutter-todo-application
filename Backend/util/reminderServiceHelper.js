const {
  repeatIntervalEnumObject,
} = require("../constants/reminderConstants");

exports.findNextOccurrenceDate = (
  currentDate,
  expiryDate,
  repeatDays
) => {
  const expiryDayOfWeek = expiryDate.getDay();

  // Convert repeatDays strings to corresponding numbers (0-6)
  const dayMap = {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
  };

  const repeatDayNumbers = repeatDays.map(
    (day) => dayMap[day.toLowerCase()]
  );

  console.log("repeatDayNumbers", repeatDayNumbers);
  console.log("currentDayOfWeek", expiryDayOfWeek);

  // Find the next upcoming repeat day
  let newDay;
  for (const dayIndex in repeatDayNumbers) {
    if (expiryDayOfWeek === repeatDayNumbers[dayIndex]) {
      newDay =
        dayIndex == repeatDayNumbers.length - 1
          ? repeatDayNumbers[0]
          : repeatDayNumbers[+dayIndex + 1];

      break;
    }
  }

  // Calculate the date of the next occurrence
  const dayDifference = (newDay - expiryDayOfWeek + 7) % 7 || 7;
  const nextOccurrence = new Date(expiryDate);
  nextOccurrence.setDate(expiryDate.getDate() + dayDifference);

  console.log("nextOccurrence", nextOccurrence);

  return nextOccurrence;
};

exports.calculateNextReminderDate = (
  currentDate,
  lastReminderDate,
  repeatInterval,
  repeatDays = []
) => {
  const nextDate = new Date(lastReminderDate);

  switch (repeatInterval) {
    case repeatIntervalEnumObject.daily:
      nextDate.setDate(nextDate.getDate() + 1);
      break;

    case repeatIntervalEnumObject.weekly:
      nextDate.setDate(nextDate.getDate() + 7);
      break;

    case repeatIntervalEnumObject.monthly:
      nextDate.setMonth(nextDate.getMonth() + 1);
      break;

    case repeatIntervalEnumObject.yearly:
      nextDate.setFullYear(nextDate.getFullYear() + 1);
      break;

    case repeatIntervalEnumObject.custom:
      return this.findNextOccurrenceDate(
        currentDate,
        lastReminderDate,
        repeatDays
      );

    default:
      throw new Error("Invalid repeat interval");
  }

  return nextDate;
};
