const { Router } = require("express");
const { body } = require("express-validator");

const authService = require("../services/authService");
const validation = require("../middlewares/validationMiddleware");

const router = Router();

//endpoint to create/signup a new user
router.post(
  "/signup",
  [
    body("email").isEmail().normalizeEmail().notEmpty().trim(),
    body("name").notEmpty().trim(),
    body("password").notEmpty().trim(),
  ],
  validation.validationMiddleWare,
  authService.postCreateUser
);

//endpoint to login a user
router.post(
  "/login",
  [
    body("email").isEmail().normalizeEmail().notEmpty().trim(),
    body("password").notEmpty().trim(),
  ],
  validation.validationMiddleWare,
  authService.postLoginUser
);

exports.AuthController = router;
