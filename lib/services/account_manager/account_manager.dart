import 'package:shared_preferences/shared_preferences.dart';

class AccountManager {
  // Save account details (email and UID)
  Future<void> saveAccountDetails(
      String email, String uid, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing accounts
    List<String> accounts = prefs.getStringList('accounts') ?? [];

    // Add the new account UID if not already present
    if (!accounts.contains(uid)) {
      accounts.add(uid);
      await prefs.setStringList(
          'accounts', accounts); // Save updated account list
    }

    // Save the email linked to the UID
    await prefs.setString(
      'user_$uid',
      email,
    );
    // Save the password linked to the UID
    await prefs.setString(
      'pass_user_$uid',
      password,
    );
    print("Pass :: ${prefs.getString('pass_user_$uid')}");
  }

  // Get all stored accounts
  Future<Map<String, String>> getAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> accounts = prefs.getStringList('accounts') ?? [];
    Map<String, String> accountDetails = {};

    for (String uid in accounts) {
      String? email = prefs.getString('user_$uid');
      String? pass = prefs.getString('pass_user_$uid');
      if (email != null && pass != null) {
        accountDetails[uid] = email;
        accountDetails["${uid}_pass"] = pass;
      }
    }

    return accountDetails;
  }

  // Set the active account UID
  Future<void> setActiveAccount(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_account', uid);
  }

  // Get the active account UID
  Future<String?> getActiveAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('active_account');
  }
}
