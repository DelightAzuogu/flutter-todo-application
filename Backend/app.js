const express = require("express");
const cors = require("cors");
require("dotenv").config();

const { AuthController } = require("./controllers/authController");
const {
  ReminderController,
} = require("./controllers/reminderController");
const database_init = require("./util/database");
const {
  EmailTransporter: transporter,
} = require("./util/emailHelper");
const { LabelController } = require("./controllers/labelController");

const app = express();

app.use(cors());

app.use(express.json());

app.use("/auth", AuthController);
app.use("/reminder", ReminderController);
app.use("/label", LabelController);

app.use((req, res) => {
  res.status(404).json("this route does not exist");
});

app.use((err, req, res, next) => {
  console.log(err);
  const status = err.status || 500;
  const message = err.message || "server Error";
  const data = err.data;
  res.status(status).json({ message, data });
});

database_init(() => {
  app.listen(process.env.PORT, () => {
    transporter.init();
    console.log(`Server running on port ${process.env.PORT}`);
  });
});
