// Function to delete account details
import 'package:account_management/notifiers/get_account_details_notifier.dart';
import 'package:account_management/services/image_crud/delete_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> deleteAccountDetails({
  required String accountId, // The ID of the account document to delete
  required WidgetRef ref,
  required BuildContext context,
}) async {
  try {
    // Get current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in");
      return;
    }

    // Get reference to the current user's document in Firestore
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Get reference to the account document to be deleted
    DocumentReference accountDocRef =
        userDocRef.collection('accounts').doc(accountId);

    // Delete account document
    await accountDocRef.delete();
    await deleteImage(accountId);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Deleted Successfully")));
    ref.invalidate(getAccountDetailsFutureProvider);

    print("Account details deleted successfully");
  } catch (e) {
    print("Error deleting account details: $e");
  }
}
