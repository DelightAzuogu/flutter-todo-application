require("dotenv").config();

exports.firstTimeReminder = (reminder, token) => {
  const completeReminderUrl = `${process.env.BASE_URL}/reminder/complete-reminder?id=${reminder._id}&token=${token}`;

  return `
  <html>
  <head>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f6f6f6;
      }
      .container {
        width: 100%;
        padding: 20px;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        margin: 20px auto;
      }
      .header {
        text-align: center;
        padding-bottom: 20px;
      }
      .header h1 {
        margin: 0;
        color: #333333;
      }
      .content {
        padding: 20px;
      }
      .content h2 {
        color: #333333;
      }
      .content p {
        font-size: 16px;
        line-height: 1.5;
        color: #666666;
      }
      .button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #007bff;
        border-radius: 5px;
        text-decoration: none;
        margin-top: 20px;
      }
      .footer {
        text-align: center;
        padding-top: 20px;
        font-size: 14px;
        color: #999999;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h1>Reminder Notification</h1>
      </div>
      <div class="content">
        <h2>${reminder.title}</h2>
        <p>${reminder.description}</p>
        <p><strong>Expiry Date:</strong> ${reminder.expiryDate.toString()}</p>
        <p>Please take the necessary actions to complete this reminder.</p>
        <a href="${completeReminderUrl}" class="button">Complete Reminder</a>
      </div>
      <div class="footer">
        <p>This is an automated message. Please do not reply to this email.</p>
      </div>
    </div>
  </body>
  </html>
  `;
};
