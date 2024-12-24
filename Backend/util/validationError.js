const { validationResult } = require("express-validator");

module.exports = (req) => {
  const valErr = validationResult(req);
  if (!valErr.isEmpty()) {
    const err = new Error("validation error");
    err.status = 401;
    err.data = valErr.array();
    return err;
  }
  return null;
};
