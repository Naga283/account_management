import 'dart:io';

import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/new/components/new_home_screen.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:account_management/providers/authentication/profile_pic_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<void> login(String email, String password, BuildContext context) async {
  final LocalAccountManager accountManager = LocalAccountManager();

  final val = accountManager.loginUser(
    email,
    password,
  );
  print(val);
  if (val != null) {
    await accountManager.isLoggedIn();
    // Navigate to home screen
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NewHomeScreen()));
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
    );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return NewHomeScreen();
    }), (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
  } catch (e, sT) {
    debugPrint("$e stack Trace :: $sT");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {}
}

Future<void> pickProfilePicture(WidgetRef ref) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    ref.read(profilePicStateProvider.notifier).state = File(pickedFile.path);
  }
}
