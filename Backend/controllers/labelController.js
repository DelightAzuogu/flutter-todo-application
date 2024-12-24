const { Router } = require("express");
const { body } = require("express-validator");

const validation = require("../middlewares/validationMiddleware");
const labelService = require("../services/labelService");
const userAuthMiddleware = require("../middlewares/userAuthMiddleware");

const router = Router();

// create label
router.post(
  "/create",
  validation.validationMiddleWare,
  userAuthMiddleware,
  labelService.postCreateLabel
);

// delete label
router.post(
  "/delete/:labelId",
  validation.validationMiddleWare,
  userAuthMiddleware,
  labelService.deleteLabel
);

//get all labels
router.get(
  "/user/all",
  userAuthMiddleware,
  labelService.getAllUsersLabels
);

exports.LabelController = router;
