String formatPhoneNumber(String input) {
  String phoneNum = input.trim();
  phoneNum = phoneNum.replaceAll(' ', '');

  // if number is in the correct format
  if (phoneNum.startsWith('+90')) {
    return phoneNum;
  }

  // if user entered 0 at the beginning
  if (phoneNum.startsWith('0')) {
    phoneNum = phoneNum.substring(1);
  }

  return '+90$phoneNum';
}
