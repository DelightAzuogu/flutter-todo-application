const { Schema, default: mongoose } = require("mongoose");

const labelSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  isDeleted: {
    type: Boolean,
    default: false,
    required: true,
  },
});

exports.Label = mongoose.model("Label", labelSchema);
