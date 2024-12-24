// Check if date time is creater than current date time

exports.isDateTimeValid = (dateTime) => {
  const currentDateTime = new Date();

  currentDateTime.setHours(currentDateTime.getHours() + 3);

  return dateTime > currentDateTime;
};
