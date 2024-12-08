import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/services/account_manager/account_manager.dart';
import 'package:account_management/services/get_current_user_name.dart';
import 'package:account_management/splash_screen.dart';
import 'package:account_management/view/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> registerWithEmailAndPassword(String fullName, String email,
    String password, BuildContext context, WidgetRef ref) async {
  try {
    ref.read(isLoadingStateProvider.notifier).state = true;
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Once the user is registered, you can save the full name to a database, Firestore, or any other storage method.
    // Example using Firebase Firestore:
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({
      'full_name': fullName,
      'email': email,
    });
    User? user = userCredential.user; // Get the User object
    if (user != null) {
      await AccountManager()
          .saveAccountDetails(user.email ?? '', user.uid, password);
      await AccountManager().setActiveAccount(user.uid);
    }
    await getCurrentUserFullName(ref);
    ref.read(isLoadingStateProvider.notifier).state = false;
    // Handle success or navigate to the next screen.
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (builder) {
      return const HomeScreen();
    }), (route) => false);
  } catch (e) {
    ref.read(isLoadingStateProvider.notifier).state = false;
    if (e is FirebaseAuthException) {
      // Fluttertoast.showToast(msg: e.code);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
      // Handle the error based on the code or show a user-friendly message.
    } else {
      // Handle other types of exceptions or errors here.
    }
  }
}

//Logout
Future<void> logoutUser(context, WidgetRef ref) async {
  try {
    await FirebaseAuth.instance.signOut();
    // ref.read(takenDocumentIdStateProvider.notifier).state = [];
    // ref.read(takenBooksCountValueStateProvider.notifier).state = 0;
    // ref.read(returnCountStateProvider.notifier).state = 0;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (builder) {
      return const SplashScreen();
    }), (route) => false);
  } catch (e) {
    throw Exception();
  }
}

//Login With Email and Password
Future<void> loginWithEmailAndPassword(
    String email, String password, BuildContext context, WidgetRef ref) async {
  try {
    ref.read(isLoadingStateProvider.notifier).state = true;
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user; // Get the User object
    if (user != null) {
      await AccountManager().saveAccountDetails(
        user.email ?? '',
        user.uid,
        password,
      );
      await AccountManager().setActiveAccount(user.uid);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in as ${user?.email}')),
    );
    await getCurrentUserFullName(ref);
    ref.read(isLoadingStateProvider.notifier).state = false;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (builder) {
      return const HomeScreen();
    }), (route) => false);
  } catch (e) {
    ref.read(isLoadingStateProvider.notifier).state = false;
    if (e is FirebaseAuthException) {
      // Fluttertoast.showToast(msg: e.code);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
      // ref.read(errorTextFormProvider.notifier).state = e.code;
      // Handle the error based on the code or show a user-friendly message.
    } else {
      // Handle other types of exceptions or errors here.
    }
  }
}
