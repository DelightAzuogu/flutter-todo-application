const jwt = require("jsonwebtoken");
const { customError } = require("../util/customError.js");
const { ResponseMessage } = require("../response/responseMessages.js");
const { User } = require("../models/user.js");
require("dotenv").config();

module.exports = async (req, res, next) => {
  try {
    const authHeader = req.get("Authorization");
    if (!authHeader) {
      throw customError(ResponseMessage.InvalidAuthToken, 401);
    }

    const token = authHeader.split(" ")[1];
    if (!token) {
      throw customError(ResponseMessage.InvalidAuthToken, 401);
    }

    let payload = jwt.verify(token, process.env.JWT_SECRET);
    if (!payload) {
      throw customError(ResponseMessage.InvalidAuthToken, 401);
    }

    const user = await User.findById(payload.id);
    if (!user) {
      throw customError(ResponseMessage.UserNotFound, 404);
    }

    req.userId = payload.id;
    req.user = user;
    next();
  } catch (err) {
    next(err);
  }
};
