import 'package:account_management/common/constants/hive_box_name.dart';
import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/services/details/add_name.dart';
import 'package:account_management/services/details/delete_name.dart';
import 'package:account_management/services/account_manager/is_mobile_number_register.dart';
import 'package:account_management/services/details/update_name.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalAccountManager {
  final Box _userBox = Hive.box(commonBox);
  final Box islogged = Hive.box(isLoggedInBox);

  // Save a new user
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String mobileNo,
    required String email,
    required String password,
    String? profilePicPath,
    required BuildContext context,
  }) async {
    try {
      if (isMobileRegistered(mobileNo)) {
        scaffoldMessage(context, "Mobile is already registered");
        throw Exception("Mobile is already registered");
      } else {
        final uid = email.hashCode.toString(); // Generate unique UID
        final userData = {
          'uid': uid,
          'first_name': firstName,
          'last_name': lastName,
          'mobile_no': mobileNo,
          'email': email,
          'password': password,
          'profilePic': profilePicPath,
          'listData': []
        };

        await _userBox.put(uid, userData);
        await _userBox.put('active_user', uid);
        await islogged.put(isLoggedInBox, true);
        print("User registered: $email");
      }
    } catch (e, sT) {
      print("erro :: $e and stackTrace :: $sT");
      throw Exception();
    }
  }

  // Login a user
  Map<String, dynamic>? loginUser(String email, String password) {
    final user = _userBox.values.firstWhere(
      (user) {
        print("${user['email']}");
        // return user['email'] == email;
        return user['email'] == email && user['password'] == password;
      },
      orElse: () => null,
    );

    if (user == null) return null;

    final uid = email.hashCode.toString();
    _userBox.put('active_user', uid);

    return Map<String, dynamic>.from(user);
  }

  // Logout active user
  Future<void> logout() async {
    await _userBox.delete('active_user');
    await islogged.delete(isLoggedInBox);
  }

  Future<void> addNameValue({required String title}) async {
    await addName(title: title);
  }

  // IsLoggedIn
  Future<void> isLoggedIn() async {
    await islogged.put(isLoggedInBox, true);
    debugPrint("isLoggedIn :: $isLoggedIn");
  }

//get LoggedIn
  bool getLoggedIn() {
    final res = islogged.get(isLoggedInBox);
    return res ?? false;
  }

// Retrieve account details by UID
  Map<String, dynamic>? getAccountDetails(String uid) {
    final data = _userBox.get(uid);
    if (data != null && data is Map<dynamic, dynamic>) {
      return Map<String, dynamic>.from(data); // Cast to Map<String, dynamic>
    }
    return null;
  }

  // Set the active account
  Future<void> setActiveAccount(String uid) async {
    await _userBox.put('active_user', uid);
    debugPrint("Active account set to: $uid");
  }

  // Get the active account UID
  String? getActiveAccount() {
    final activeUser = _userBox.get('active_user');
    debugPrint("Active account UID: $activeUser");
    return activeUser;
  }

  // Retrieve data for the active account
  Map<String, dynamic>? getActiveAccountDetails() {
    final activeUid = getActiveAccount();
    if (activeUid != null) {
      return getAccountDetails(activeUid);
    }
    return null;
  }

  // Retrieve all users
  List<String> getAllUsers() {
    return _userBox.keys
        .where((key) => key != 'active_user')
        .cast<String>()
        .toList();
  }

  Future<void> updateNameValue(
      {required String newTitle, required int index}) async {
    await updateName(newTitle: newTitle, index: index);
  }

  Future<void> deleteNameValue({required int index}) async {
    await deleteName(index: index);
  }
}
