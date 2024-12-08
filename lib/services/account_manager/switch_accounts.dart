import 'package:account_management/services/account_manager/account_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> switchAccount(String uid, BuildContext context) async {
  await AccountManager().setActiveAccount(uid);

  // Sign out the current user and sign in with the selected account
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser?.uid != uid) {
    await FirebaseAuth.instance.signOut();

    String? email = await AccountManager()
        .getAllAccounts()
        .then((accounts) => accounts[uid]);
    if (email != null) {
      // Sign back in (if using stored password, you may need a secure method)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to account: $email')),
      );
    }
  }
}
