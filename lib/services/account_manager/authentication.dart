import 'dart:io';

import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/view/home_screen/home_screen.dart';
import 'package:account_management/services/account_manager/local_storage_manager.dart';
import 'package:flutter/material.dart';

Future<void> login(String email, String password, BuildContext context) async {
  final LocalAccountManager accountManager = LocalAccountManager();

  final val = accountManager.loginUser(
    email,
    password,
  );
  if (val != null) {
    await accountManager.isLoggedIn();
    // Navigate to home screen
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  } else {
    scaffoldMessage(context, "Invalid Credentials");
  }
}

Future<void> registerUser({
  required String firstName,
  required String lastName,
  required String mobileNumber,
  required String emailVal,
  required String pass,
  File? profilPic,
  required BuildContext context,
  required LocalAccountManager accountManager,
}) async {
  final email = emailVal.trim();
  final password = pass.trim();

  if (email.isEmpty ||
      password.isEmpty ||
      profilPic == null ||
      mobileNumber.isEmpty ||
      firstName.isEmpty ||
      lastName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please fill all fields and select a profile picture')),
    );
    return;
  }

  try {
    await accountManager.registerUser(
      email: email,
      password: password,
      profilePicPath: profilPic.path,
      firstName: firstName,
      lastName: lastName,
      mobileNo: mobileNumber,
      context: context,
    );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }), (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
  } catch (e, sT) {
    debugPrint("$e stack Trace :: $sT");
  } finally {}
}
