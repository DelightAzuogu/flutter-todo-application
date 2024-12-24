const nodemailer = require("nodemailer");
const { firstTimeReminder } = require("./reminderHtml");
const jwt = require("jsonwebtoken");

require("dotenv").config();

const signToken = (id) => {
  return jwt.sign(
    {
      id: id,
    },
    process.env.JWT_SECRET
  );
};

let transporter;

exports.EmailTransporter = {
  init: () => {
    transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL,
        pass: process.env.EMAIL_PASSWORD,
      },
    });
  },
  getTransporter: () => {
    if (!transporter) {
      throw new Error("transporter not initialized");
    }
    return transporter;
  },
};

exports.SendReminderEmail = async (reminder) => {
  let message = {
    from: "email",
    to: reminder.user.email,
    subject: "Reminder",
    html: firstTimeReminder(reminder, signToken(reminder.user.id)),
  };

  let transporter = this.EmailTransporter.getTransporter();

  console.log("sending mail to", reminder.user.email);

  // sending reminder email
  await transporter.sendMail(message);

  console.log("Reminder sent successfully");
};
