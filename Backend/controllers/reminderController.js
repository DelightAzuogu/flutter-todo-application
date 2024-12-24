const { Router } = require("express");
const { body, param } = require("express-validator");

const reminderService = require("../services/reminderService");
const validation = require("../middlewares/validationMiddleware");
const userAuthMiddleWare = require("../middlewares/userAuthMiddleware");

const router = Router();

// create reminder
router.post(
  "/create",
  validation.validationMiddleWare,
  userAuthMiddleWare,
  reminderService.postCreateReminders
);

//get user reminders
router.get(
  "/user/all",
  userAuthMiddleWare,
  reminderService.getUserReminders
);

// get user reminder by date
router.get(
  "/user/all/date",
  userAuthMiddleWare,
  reminderService.getUserReminderByDate
);

// get user reminder by date
router.get(
  "/user/all/date/completed",
  userAuthMiddleWare,
  reminderService.getUserCompletedReminderByDate
);

// get static html page to complete reminder
router.get(
  "/complete-reminder",
  reminderService.getStaticCompleteReminderHtml
);

//get reminder by Id
router.get(
  "/:id",
  userAuthMiddleWare,
  reminderService.getReminderById
);

// update reminder
router.post(
  "/update/:reminderId",
  [
    body("title").notEmpty().trim(),
    body("description").notEmpty().trim(),
    body("expiryDate").notEmpty().trim(),
    param("reminderId").notEmpty().trim(),
  ],
  validation.validationMiddleWare,
  userAuthMiddleWare,
  reminderService.postUpdateReminder
);

// complete reminder
router.post(
  "/complete/:reminderId",
  param("reminderId").notEmpty().trim(),
  validation.validationMiddleWare,
  userAuthMiddleWare,
  reminderService.postCompleteReminder
);

// delete reminder
router.post(
  "/delete/:reminderId",
  param("reminderId").notEmpty().trim(),
  validation.validationMiddleWare,
  userAuthMiddleWare,
  reminderService.postDeleteReminder
);

// assign label to reminder
router.post(
  "/assign-label",
  [
    body("labelId").optional().trim(),
    body("reminderId").notEmpty().trim(),
  ],
  validation.validationMiddleWare,
  userAuthMiddleWare,
  reminderService.postAssignLabelToReminder
);

// get label reminders
router.get(
  "/label/:labelId",
  userAuthMiddleWare,
  reminderService.getLabelReminders
);

exports.ReminderController = router;
