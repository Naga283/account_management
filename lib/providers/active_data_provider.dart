import 'package:account_management/services/account_manager/local_storage_manager.dart';
import 'package:flutter/material.dart';

class ActiveAccountNotifier extends ValueNotifier<Map<String, dynamic>?> {
  final LocalAccountManager accountManager;

  ActiveAccountNotifier(this.accountManager)
      : super(accountManager.getActiveAccountDetails());

  void switchAccount(String uid) async {
    await accountManager.setActiveAccount(uid);
    value = accountManager.getActiveAccountDetails();
  }

  void refresh() {
    value = accountManager.getActiveAccountDetails();
  }
}
