
bool validEmail(String email){
  return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email);
}

bool validLink(String link) {
  String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = new RegExp(pattern);
  if (link.length == 0 || !regExp.hasMatch(link)) {
    return false;
  }
  return true;
}


bool validPhone(String value){
  return value.trim().length >= 8;
}
bool validArabicName(String value){
  return value.split(' ').length == 4;
}
bool validName(String value){
  return value.trim().length >= 3;
}
bool notEmptyString(String value){
  return value.trim().isNotEmpty;
}
bool validNationalId(String value){
  return value.trim().length == 14;
}

bool validPassword(String value){
  return value.trim().isNotEmpty && value.trim().length >= 8;
}

bool validConfirmPassword(String password, String confirmPassword){
  return password.trim().isNotEmpty && password.trim().length >= 8 && password.trim() == confirmPassword.trim();
}

bool validUserNameEmail(String name) {
  String pattern = '([a-zA-Z])';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(name);
}

