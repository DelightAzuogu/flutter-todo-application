const {
  reminderStatusArray,
  reminderStatusObject,
  priorityEnum,
  repeatDaysEnum,
  repeatIntervalEnum,
} = require("../constants/reminderConstants");

const { Schema, default: mongoose, Types } = require("mongoose");

const reminderSchema = new Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: false,
  },
  expiryDate: {
    type: Date,
    default: Date.now,
    required: true,
  },
  status: {
    type: String,
    enum: reminderStatusArray,
    default: reminderStatusObject.pending,
    required: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    required: false,
  },
  lastReminderSent: {
    type: Date,
    default: null,
    required: false,
  },
  priority: {
    type: String,
    enum: priorityEnum,
    default: "medium",
    required: true,
  },
  repeatInterval: {
    type: String,
    enum: repeatIntervalEnum,
    default: repeatIntervalEnum.none,
    required: true,
  },
  repeatEndDate: {
    type: Date,
    default: null,
    required: false,
  },
  repeatDays: {
    type: [String],
    enum: repeatDaysEnum,
    default: [],
    required: false,
  },
  label: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Label",
    required: false,
    default: null,
  },
});

exports.Reminder = mongoose.model("Reminder", reminderSchema);
