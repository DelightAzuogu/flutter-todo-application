const {
  reminderStatusObject,
  repeatIntervalEnumObject,
} = require("../constants/reminderConstants");
const { Reminder } = require("../models/reminders");
const { ResponseMessage } = require("../response/responseMessages");
const { customError } = require("../util/customError");
require("dotenv").config();
const path = require("path");
const {
  isValidPriority,
  isValidRepeatInterval,
  isValidRepeatDay,
} = require("../helpers/enumHelper");
const {
  findNextOccurrenceDate,
  calculateNextReminderDate,
} = require("../util/reminderServiceHelper");
const { SendReminderEmail } = require("../util/emailHelper");
const { Label } = require("../models/label");
const moment = require("moment-timezone");

//check for expired reminder
//this goes off every 1 minute(60000 millseconds )
setInterval(async () => {
  // One week in milliseconds
  const oneWeekInMilliseconds = 604800000;

  let currentDate = new Date();

  //getting reminders that are expired and pending
  const expiredReminders = await Reminder.find({
    expiryDate: {
      $lte: currentDate,
    },
    status: reminderStatusObject.pending,
  });

  // reminders that have not been sent before
  const filteredReminders = expiredReminders.filter(
    (reminder) =>
      !reminder.lastReminderSent ||
      reminder.lastReminderSent <
        new Date(currentDate - oneWeekInMilliseconds)
  );

  if (filteredReminders.length > 0) {
    // send mail to the user concerning the reminder
    for (let reminder of filteredReminders) {
      const reminderToSend = await reminder.populate("user");

      try {
        SendReminderEmail(reminderToSend);

        reminder.lastReminderSent = currentDate;
        reminder = await reminder.save();
      } catch (error) {
        console.log(error);
      }

      // Fix the currentDateDate calculation
      const currentDateDate = new Date(
        currentDate.getFullYear(),
        currentDate.getMonth(),
        currentDate.getDate(),
        0,
        0,
        0,
        0
      );

      if (
        reminder.repeatInterval !== repeatIntervalEnumObject.none &&
        (!reminder.repeatEndDate ||
          currentDateDate < reminder.repeatEndDate)
      ) {
        consol.log("calculating the next reminder date");

        // Calculate the next reminder date
        const nextReminderDate = calculateNextReminderDate(
          currentDate,
          reminder.expiryDate,
          reminder.repeatInterval,
          reminder.repeatDays
        );

        // Check if the next reminder date is before the repeat end date
        if (
          !reminder.repeatEndDate ||
          nextReminderDate < reminder.repeatEndDate
        ) {
          console.log("Creating a new reminder");
          // Create the new reminder
          await Reminder.create({
            title: reminder.title,
            description: reminder.description,
            expiryDate: nextReminderDate,
            status: reminderStatusObject.pending,
            user: reminder.user,
            repeatInterval: reminder.repeatInterval,
            repeatEndDate: reminder.repeatEndDate,
            repeatDays: reminder.repeatDays,
            priority: reminder.priority,
            label: reminder.label,
          });
        }
      }
    }
  }
}, 60000);

exports.postCreateReminders = async (req, res, next) => {
  try {
    const {
      title,
      description,
      expiryDate,
      repeatInterval,
      repeatEndDate,
      repeatDays,
      priority,
    } = req.body;

    const currentDate = new Date();

    // Parse expiryDate from string to Date object
    const parsedExpiryDate = new Date(expiryDate);

    // Validate expiryDate
    if (isNaN(parsedExpiryDate) || parsedExpiryDate < currentDate) {
      throw customError(ResponseMessage.InvalidDate, 400);
    }

    // Validate priority
    if (!isValidPriority(priority)) {
      throw customError(ResponseMessage.invalidPriority, 400);
    }

    // Validate repeatInterval
    if (repeatInterval && !isValidRepeatInterval(repeatInterval)) {
      throw customError(ResponseMessage.InvalidRepeatIntervals, 400);
    }

    // Validate repeatDays if repeatInterval is custom
    if (repeatInterval === repeatIntervalEnumObject.custom) {
    }

    // Parse repeatEndDate
    const parsedEndDate = new Date(repeatEndDate);
    if (
      repeatEndDate &&
      (isNaN(parsedEndDate) || parsedEndDate < currentDate)
    ) {
      throw customError(ResponseMessage.invalidEndDate, 400);
    }

    let reminder;

    if (repeatInterval === repeatIntervalEnumObject.custom) {
      if (
        !repeatDays ||
        !Array.isArray(repeatDays) ||
        repeatDays.length === 0
      ) {
        throw customError(ResponseMessage.InvalidRepeatDays, 400);
      }

      // Check if all repeatDays are valid
      if (!repeatDays.every((day) => isValidRepeatDay(day))) {
        throw customError(ResponseMessage.InvalidRepeatDays, 400);
      }

      const nextOccurrence = findNextOccurrenceDate(
        currentDate,
        parsedExpiryDate,
        repeatDays
      );

      reminder = await Reminder.create({
        title,
        description,
        expiryDate: nextOccurrence,
        status: reminderStatusObject.pending,
        user: req.userId,
        repeatInterval: repeatInterval,
        repeatEndDate: parsedEndDate,
        repeatDays: repeatDays,
        priority,
      });
    } else {
      reminder = await Reminder.create({
        title,
        description,
        expiryDate: parsedExpiryDate,
        status: reminderStatusObject.pending,
        user: req.userId,
        repeatInterval: repeatInterval,
        repeatEndDate: parsedEndDate,
        repeatDays: null,
        priority,
      });
    }

    res.status(201).json({
      id: reminder._id,
      title: reminder.title,
      description: reminder.description,
      expiryDate: reminder.expiryDate,
      status: reminder.status,
      repeatInterval: reminder.repeatInterval,
      repeatEndDate: reminder.repeatEndDate,
      repeatDays: reminder.repeatDays,
      priority: reminder.priority,
    });
  } catch (error) {
    next(error);
  }
};

// getting a user reminders
exports.getUserReminders = async (req, res, next) => {
  try {
    // get all pending reminders for the logged in user
    const reminders = await Reminder.find({
      user: req.userId,
      status: reminderStatusObject.pending,
    }).sort({
      expiryDate: 1,
    });

    await Promise.all(
      reminders.map((reminder) => reminder.populate("label"))
    );

    // converting the reminders to DTO
    const reminderList = reminders.map((reminder) => {
      return {
        id: reminder._id,
        title: reminder.title,
        description: reminder.description,
        expiryDate: reminder.expiryDate,
        status: reminder.status,
        repeatInterval: reminder.repeatInterval,
        repeatEndDate: reminder.repeatEndDate,
        repeatDays: reminder.repeatDays,
        priority: reminder.priority,
      };
    });

    res.status(200).json(reminderList);
  } catch (error) {
    next(error);
  }
};

exports.getUserReminderByDate = async (req, res, next) => {
  try {
    // Validate and parse date input
    const { date } = req.query;

    if (!date) {
      return res.status(400).json({
        message: "Date parameter is required",
      });
    }

    // Use moment for robust date parsing and timezone handling
    const parsedDate = moment(date);

    if (!parsedDate.isValid()) {
      return res.status(400).json({
        message: "Invalid date format",
      });
    }

    // Set start and end of day in the user's timezone
    const startOfDay = parsedDate.startOf("day").toDate();
    const endOfDay = parsedDate.endOf("day").toDate();

    // Refined query with additional optimization
    const reminders = await Reminder.find({
      user: req.userId,
      expiryDate: {
        $gte: startOfDay,
        $lte: endOfDay,
      },
      status: reminderStatusObject.pending,
    }).populate("label");

    // Transform reminders with safe object mapping
    const reminderList = reminders.map((reminder) => ({
      id: reminder._id,
      title: reminder.title ?? "",
      description: reminder.description ?? "",
      expiryDate: reminder.expiryDate,
      status: reminder.status,
      repeatInterval: reminder.repeatInterval,
      repeatEndDate: reminder.repeatEndDate,
      repeatDays: reminder.repeatDays,
      priority: reminder.priority,
      label: reminder.label
        ? {
            id: reminder.label._id,
            name: reminder.label.name,
          }
        : null,
    }));

    res.status(200).json(reminderList);
  } catch (error) {
    // Centralized error handling
    console.error("Get User Reminders Error:", error);
    next(error);
  }
};

//get a reminder by id
exports.getReminderById = async (req, res, next) => {
  try {
    // Get the reminder ID from request parameters
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        message: "Reminder ID is required",
      });
    }

    // Find the reminder by ID
    const reminder = await Reminder.findById(id);

    if (!reminder) {
      return res.status(404).json({
        message: "Reminder not found",
      });
    }

    await reminder.populate("label");

    // Convert the reminder to DTO
    const reminderDto = {
      id: reminder._id,
      title: reminder.title,
      description: reminder.description,
      expiryDate: reminder.expiryDate,
      status: reminder.status,
      repeatInterval: reminder.repeatInterval,
      repeatEndDate: reminder.repeatEndDate,
      repeatDays: reminder.repeatDays,
      priority: reminder.priority,
      label: reminder.label
        ? {
            id: reminder.label._id,
            name: reminder.label.name,
          }
        : null,
    };

    res.status(200).json(reminderDto);
  } catch (error) {
    next(error);
  }
};

// updating a reminder
exports.postUpdateReminder = async (req, res, next) => {
  try {
    const { reminderId } = req.params;
    const {
      title,
      description,
      expiryDate,
      repeatInterval,
      repeatEndDate,
      repeatDays,
      priority,
    } = req.body;

    // get reminder
    let reminder = await Reminder.findById(reminderId);
    if (!reminder) {
      throw customError(ResponseMessage.ReminderNotFound, 404);
    }
    reminder = await reminder.populate("user");

    // check if reminder belongs to user
    if (reminder.user.id != req.userId) {
      throw customError(
        ResponseMessage.ReminderDoesNotBelongToUser,
        403
      );
    }

    const currentDate = new Date();

    // parse expiryDate from string to Date object
    const parsedExpiryDate = new Date(expiryDate);

    // validate expiryDate
    if (
      expiryDate &&
      (isNaN(parsedExpiryDate) || parsedExpiryDate < currentDate)
    ) {
      throw customError(ResponseMessage.InvalidDate, 400);
    }

    // validate priority
    if (priority && !isValidPriority(priority)) {
      throw customError(ResponseMessage.invalidPriority, 400);
    }

    // validate repeatInterval
    if (repeatInterval && !isValidRepeatInterval(repeatInterval)) {
      throw customError(ResponseMessage.InvalidRepeatIntervals, 400);
    }

    // validate repeatDays
    if (
      repeatInterval &&
      repeatDays &&
      !repeatDays.every((day) => isValidRepeatDay(day))
    ) {
      throw customError(ResponseMessage.InvalidRepeatDays, 400);
    }

    // parse repeatEndDate
    const parsedEndDate = new Date(repeatEndDate);
    if (
      repeatInterval &&
      repeatEndDate &&
      (isNaN(parsedEndDate) || parsedEndDate < currentDate)
    ) {
      throw customError(ResponseMessage.invalidEndDate, 400);
    }

    // update reminder fields
    reminder.title = title;
    reminder.description = description;
    reminder.expiryDate = parsedExpiryDate;
    reminder.status = reminderStatusObject.pending;
    reminder.repeatInterval = repeatInterval;
    reminder.repeatEndDate = repeatInterval ? parsedEndDate : null;
    reminder.repeatDays =
      repeatInterval === repeatIntervalEnumObject.custom
        ? repeatDays
        : null;
    reminder.priority = priority;

    // reset lastReminderSent since the reminder details have changed
    reminder.lastReminderSent = null;

    // save the updated reminder
    reminder = await reminder.save();

    await reminder.populate("label");

    res.status(200).json({
      id: reminder._id,
      title: reminder.title,
      description: reminder.description,
      expiryDate: reminder.expiryDate,
      status: reminder.status,
      repeatInterval: reminder.repeatInterval,
      repeatEndDate: reminder.repeatEndDate,
      repeatDays: reminder.repeatDays,
      priority: reminder.priority,
      label: reminder.label
        ? {
            id: reminder.label._id,
            name: reminder.label.name,
          }
        : null,
    });
  } catch (error) {
    next(error);
  }
};

// completing a reminder
exports.postCompleteReminder = async (req, res, next) => {
  try {
    const { reminderId } = req.params;

    // get the reminder
    let reminder = await Reminder.findById(reminderId);
    if (!reminder) {
      throw customError(ResponseMessage.ReminderNotFound, 404);
    }

    //check if reminder belongs to user
    if (reminder.user != req.userId) {
      throw customError(
        ResponseMessage.ReminderDoesNotBelongToUser,
        403
      );
    }

    // update reminder status
    reminder.status = reminderStatusObject.complete;
    reminder = await reminder.save();

    const currentDate = new Date();

    // Fix the currentDateDate calculation
    const currentDateOnly = new Date(currentDate).setHours(
      0,
      0,
      0,
      0
    );

    if (
      currentDate < reminder.expiryDate &&
      reminder.repeatInterval !== repeatIntervalEnumObject.none &&
      (!reminder.repeatEndDate ||
        currentDateOnly < reminder.repeatEndDate)
    ) {
      // Calculate the next reminder date
      const nextReminderDate = calculateNextReminderDate(
        currentDate,
        reminder.expiryDate,
        reminder.repeatInterval,
        reminder.repeatDays
      );

      // Check if the next reminder date is before the repeat end date
      if (
        !reminder.repeatEndDate ||
        nextReminderDate < reminder.repeatEndDate
      ) {
        // Create the new reminder
        await Reminder.create({
          title: reminder.title,
          description: reminder.description,
          expiryDate: nextReminderDate,
          status: reminderStatusObject.pending,
          user: reminder.user,
          repeatInterval: reminder.repeatInterval,
          repeatEndDate: reminder.repeatEndDate,
          repeatDays: reminder.repeatDays,
          priority: reminder.priority,
        });
      }
    }

    res.status(200).json({
      message: "Reminder completed successfully",
    });
  } catch (error) {
    next(error);
  }
};

//delete a reminder
exports.postDeleteReminder = async (req, res, next) => {
  try {
    const { reminderId } = req.params;

    // get the reminder
    const reminder = await Reminder.findById(reminderId);
    if (!reminder) {
      throw customError(ResponseMessage.ReminderNotFound, 404);
    }

    // check if reminder belongs to user
    if (reminder.user != req.userId) {
      throw customError(
        ResponseMessage.ReminderDoesNotBelongToUser,
        403
      );
    }

    // delete the reminder
    await reminder.deleteOne();

    res.status(200).json(ResponseMessage.ReminderDeleted);
  } catch (error) {
    next(error);
  }
};

exports.getStaticCompleteReminderHtml = (req, res, next) => {
  const filePath = path.join(
    __dirname,
    "../html/completeReminder.html"
  );
  res.sendFile(filePath);
};

exports.getUserCompletedReminderByDate = async (req, res, next) => {
  try {
    // Get the date from query parameters
    const { date } = req.query;

    // Parse the date to ensure it is valid
    const parsedDate = new Date(date);
    if (isNaN(parsedDate)) {
      return res.status(400).json({ message: "Invalid date format" });
    }

    // Remove time part to focus only on the date
    parsedDate.setHours(0, 0, 0, 0);

    // Calculate end of the day for the given date
    const endOfDay = new Date(parsedDate);
    endOfDay.setHours(23, 59, 59, 999);

    // Query for completed reminders within the specified date range
    const reminders = await Reminder.find({
      user: req.userId,
      expiryDate: {
        $gte: parsedDate,
        $lte: endOfDay,
      },
      status: reminderStatusObject.complete,
    });

    await Promise.all(
      reminders.map((reminder) => reminder.populate("label"))
    );

    // Map reminders to DTO format
    const reminderList = reminders.map((reminder) => ({
      id: reminder._id,
      title: reminder.title,
      description: reminder.description,
      expiryDate: reminder.expiryDate,
      status: reminder.status,
      repeatInterval: reminder.repeatInterval,
      repeatEndDate: reminder.repeatEndDate,
      repeatDays: reminder.repeatDays,
      priority: reminder.priority,
      label: reminder.label
        ? {
            id: reminder.label._id,
            name: reminder.label.name,
          }
        : null,
    }));

    res.status(200).json(reminderList);
  } catch (error) {
    next(error);
  }
};

exports.postAssignLabelToReminder = async (req, res, next) => {
  const { reminderId, labelId } = req.body;

  try {
    const reminder = await Reminder.findById(reminderId);
    if (!reminder) {
      throw customError(ResponseMessage.ReminderNotFound, 404);
    }

    if (reminder.user != req.userId) {
      throw customError(
        ResponseMessage.ReminderDoesNotBelongToUser,
        403
      );
    }

    if (!labelId) {
      reminder.label = null;
      await reminder.save();

      return res.status(200).json({
        message: "Label removed from reminder successfully",
      });
    }

    const label = await Label.findById(labelId);

    if (!label) {
      throw customError("Label now found", 404);
    }

    if (label.user.toString() !== req.userId) {
      throw customError(
        "You are not authorized to assign this label",
        401
      );
    }

    reminder.label = labelId;
    await reminder.save();

    res.status(200).json({
      message: "Label assigned to reminder successfully",
    });
  } catch (error) {
    next(error);
  }
};

exports.getLabelReminders = async (req, res, next) => {
  try {
    const { labelId } = req.params;

    const label = await Label.findById(labelId);
    if (!label) {
      throw customError("Label not found", 404);
    }

    if (label.user.toString() !== req.userId) {
      throw customError(
        "You are not authorized to view this label",
        401
      );
    }

    const reminders = await Reminder.find({
      label: labelId,
    });

    await Promise.all(
      reminders.map((reminder) => reminder.populate("label"))
    );

    res.status(200).json(
      reminders.map((reminder) => ({
        id: reminder._id,
        title: reminder.title,
        description: reminder.description,
        expiryDate: reminder.expiryDate,
        status: reminder.status,
        repeatInterval: reminder.repeatInterval,
        repeatEndDate: reminder.repeatEndDate,
        repeatDays: reminder.repeatDays,
        priority: reminder.priority,
        label: reminder.label
          ? {
              id: reminder.label._id,
              name: reminder.label.name,
            }
          : null,
      }))
    );
  } catch (error) {
    next(error);
  }
};
