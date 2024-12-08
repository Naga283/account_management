import 'dart:io';

import 'package:account_management/notifiers/get_account_details_notifier.dart';
import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/services/image_crud/delete_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> addAccountDetails({
  required String firstName,
  required String lastName,
  required String emailId,
  required String password,
  required String mobileNo,
  File? image,
  required BuildContext context,
  required WidgetRef ref,
}) async {
  try {
    ref.read(isLoadingStateProvider.notifier).state = true;
    // Get current user's UID
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in");
      return;
    }

    // Get reference to the current user's document in Firestore
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Query the accounts collection to check if the account number already exists
    // QuerySnapshot existingAccount = await userDocRef
    //     .collection('accounts')
    //     .where('emailId', isEqualTo: emailId)
    //     .get();

    // if (existingAccount.docs.isNotEmpty) {
    //   // Account number already exists
    //   print("Account number already exists");
    //   ref.read(isLoadingStateProvider.notifier).state = false;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Email is already exists")));
    //   return;
    // }

    // If account number doesn't exist, add the account details
    final accDeta = await userDocRef.collection('accounts').add({
      'firstName': firstName,
      'lastName': lastName,
      'emailId': emailId,
      'password': password,
      'mobileNo': mobileNo,
      'createdAt': FieldValue.serverTimestamp(), // Store the timestamp
    });
    await storeImage(image, accDeta.id, ref);
    ref.read(isLoadingStateProvider.notifier).state = false;
    print("Account details added successfully");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfully Added!")));
    Navigator.of(context).pop();
    ref.invalidate(getAccountDetailsFutureProvider);
  } catch (e) {
    ref.read(isLoadingStateProvider.notifier).state = false;
    print("Error adding account details: $e");
  }
}
