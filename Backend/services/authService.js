const argon = require("argon2");
const jwt = require("jsonwebtoken");
const { ResponseMessage } = require("../response/responseMessages");
const { customError } = require("../util/customError");
const { User } = require("../models/user");

require("dotenv").config();

const signToken = (id) => {
  return jwt.sign(
    {
      id: id,
    },
    process.env.JWT_SECRET
  );
};

exports.postCreateUser = async (req, res, next) => {
  try {
    const { email, password, name } = req.body;

    //checking if user with email alsready exists
    const user = await User.findOne({ email: email });
    if (user) {
      throw customError(ResponseMessage.UserWithEmailExists, 400);
    }

    //hash the password
    const hashedPassword = await argon.hash(password);

    //create the user
    const newUser = await User.create({
      email,
      passwordHash: hashedPassword,
      name,
    });

    //sign the user jwt token
    const token = signToken(newUser._id);

    return res.status(201).json({
      id: newUser._id,
      email: newUser.email,
      name: newUser.name,
      accessToken: token,
    });
  } catch (err) {
    return next(err);
  }
};

exports.postLoginUser = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    //find the user by email
    const user = await User.findOne({ email: email });

    if (!user) {
      throw customError(ResponseMessage.InvalidEmailOrPassword, 401);
    }

    //check if password is correct
    const valid = await argon.verify(user.passwordHash, password);
    if (!valid) {
      throw customError(ResponseMessage.InvalidEmailOrPassword, 401);
    }

    //sign the user jwt token
    const token = signToken(user._id);

    res.status(200).json({
      id: user._id,
      email: user.email,
      name: user.name,
      accessToken: token,
    });
  } catch (err) {
    return next(err);
  }
};
