const {
  reminderStatusObject,
} = require("../constants/reminderConstants");
const { Label } = require("../models/label");
const { Reminder } = require("../models/reminders");
const { customError } = require("../util/customError");

function capitalizeEachWord(str) {
  if (!str || typeof str !== "string") return str;
  return str
    .split(" ")
    .map(
      (word) =>
        word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    )
    .join(" ");
}

exports.postCreateLabel = async (req, res, next) => {
  try {
    const { name } = req.body;
    const capitalizedName = capitalizeEachWord(name);

    const existingLabel = await Label.findOne({
      name: capitalizedName,
      user: req.userId,
    });

    if (existingLabel && existingLabel.isDeleted) {
      existingLabel.isDeleted = false;
      await existingLabel.save();
      return res
        .status(201)
        .json({ name: existingLabel.name, id: existingLabel._id });
    }

    if (existingLabel) {
      throw customError("Label already exists", 400);
    }

    const newLabel = await Label.create({
      name: capitalizedName,
      user: req.userId,
      isDeleted: false,
    });
    return res
      .status(201)
      .json({ name: newLabel.name, id: newLabel._id });
  } catch (error) {
    next(error);
  }
};

exports.deleteLabel = async (req, res, next) => {
  try {
    const { labelId } = req.params;
    const label = await Label.findById(labelId);
    if (!label) {
      throw customError("Label not found", 404);
    }

    if (label.user.toString() !== req.userId) {
      throw customError(
        "You are not authorized to delete this label",
        401
      );
    }

    label.isDeleted = true;
    await label.save();

    const existingReminders = await Reminder.find({
      label: labelId,
      status: reminderStatusObject.pending,
    });

    await Promise.all(
      existingReminders.map((reminder) => {
        reminder.label = null;
        return reminder.save();
      })
    );

    return res.status(200).json("Label deleted successfully");
  } catch (error) {
    next(error);
  }
};

exports.getAllUsersLabels = async (req, res, next) => {
  try {
    const labels = await Label.find({
      isDeleted: false,
      user: req.userId,
    });

    return res.status(200).json(
      labels.map((label) => ({
        name: label.name,
        id: label._id,
      }))
    );
  } catch (error) {
    next(error);
  }
};
