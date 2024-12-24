exports.customError = (data, status) => {
  const err = new Error(data);
  err.status = status;
  return err;
};
