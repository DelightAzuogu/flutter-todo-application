const validationError = require("../util/validationError");

exports.validationMiddleWare = async (req, res, next) => {
  const valError = validationError(req);
  if (valError) {
    return res.status(400).json(valError);
  } else {
    next();
  }
};
