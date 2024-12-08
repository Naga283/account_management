import 'dart:io';

import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/notifiers/get_account_details_notifier.dart';
import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/services/image_crud/delete_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Function to update account details
Future<void> updateAccountDetails({
  required String firstName, // The ID of the account document to update
  required String lastName,
  required String emailId,
  required String mobileNo,
  required String password,
  required WidgetRef ref,
  required String docId,
  File? image,
  required BuildContext context,
}) async {
  try {
    ref.read(isLoadingStateProvider.notifier).state = true;
    // Get current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    // Get reference to the current user's document in Firestore
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Get reference to the account document to be updated
    DocumentReference accountDocRef =
        userDocRef.collection('accounts').doc(docId);

    // Update account details
    await accountDocRef.update({
      'firstName': firstName,
      'lastName': lastName,
      'emailId': emailId,
      'password': password,
      'mobileNo': mobileNo,
      'updatedAt': FieldValue.serverTimestamp(), // Store the update timestamp
    });
    await updateImage(image, accountDocRef.id, ref);
    ref.read(isLoadingStateProvider.notifier).state = false;
    scaffoldMessage(context, "Successfully Updated!");
    Navigator.of(context).pop();
    ref.invalidate(getAccountDetailsFutureProvider);
    debugPrint("Account details updated successfully");
  } catch (e) {
    debugPrint("Error updating account details: $e");
    ref.read(isLoadingStateProvider.notifier).state = false;
  }
}
