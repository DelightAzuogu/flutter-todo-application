const mongoose = require("mongoose");
require("dotenv").config();

const database_init = (cb) => {
  mongoose.set("strictQuery", false);

  mongoose.connect(process.env.MONGODB_CONNECT_STRING).then(() => {
    cb();
  });

  // mongoose.connection.dropDatabase();

  mongoose.connection.on("connected", () => {
    console.log("Mongoose connected to db...");
  });

  mongoose.connection.on("error", (err) => {
    console.log("error message");
    console.log(err.message);
  });

  mongoose.connection.on("disconnected", () => {
    console.log("Mongoose connection is disconnected...");
  });

  process.on("SIGINT", () => {
    mongoose.connection.close();
  });
};

module.exports = database_init;
