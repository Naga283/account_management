String? validateEmail(String? email) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (email != null && regex.hasMatch(email)) {
    return null;
  } else {
    return "Please enter valid email";
  }
}

//Validate Name
String? validateName(String? name) {
  if (name != null && name.isNotEmpty) {
    return null;
  } else {
    return "Please enter valid name";
  }
}

//Validate Password
String? validatePassword(String? pass) {
  if (pass == null && pass!.isEmpty) {
    return "Please enter Password";
  } else if (pass.length < 6) {
    return "Please enter pasword more that 6 characters";
  } else {
    return null;
  }
}

//Validate Reenter Password
String? validateReEnterPassword(String? pass, String? firstPass) {
  if (pass == null && pass!.isEmpty) {
    return "Please enter Password";
  } else if (pass != firstPass) {
    return "Please reenter correct Password";
  } else {
    return null;
  }
}

//Validate Mobile Number
String? validateMobileNumber(String? mobileNo) {
  if (mobileNo == null && mobileNo!.isEmpty) {
    return "Please enter Password";
  } else if (mobileNo.length < 10) {
    return "Please enter valid Mobile No";
  } else {
    return null;
  }
}
