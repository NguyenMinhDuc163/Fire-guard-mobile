class Utils{
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      return true;
    }
    String pattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool isCheckString(String str) {
    if (str == null || str == "") {
      return false;
    }
    return true;
  }

}