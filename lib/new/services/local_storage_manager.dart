import 'package:account_management/common/constants/hive_box_name.dart';
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
  }) async {
    try {
      // if (_isMobileRegistered(mobileNo)) {
      //   throw Exception("Mobile is already registered");
      // }

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
    } catch (e, sT) {
      print("erro :: $e and stackTrace :: $sT");
      throw Exception();
    }
  }

  // Check if an email is already registered
  bool _isMobileRegistered(String mobileNumber) {
    return _userBox.values.any((user) => user['mobile_no'] == mobileNumber);
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

  // Save account details
  Future<void> saveAccount(String uid, String email, String password,
      Map<String, dynamic> additionalData) async {
    await _userBox.put(uid, {
      'uid': uid,
      'email': email,
      'password': password, // Store securely in production
      ...additionalData,
    });
    await isLoggedIn();
    print("Saved data for $uid: ${_userBox.get(uid)}");
  }

  // IsLoggedIn
  Future<void> isLoggedIn() async {
    await islogged.put(isLoggedInBox, true);
    print("isLoggedIn :: $isLoggedIn");
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
    print("Active account set to: $uid");
  }

  // Get the active account UID
  String? getActiveAccount() {
    final activeUser = _userBox.get('active_user');
    print("Active account UID: $activeUser");
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

  // Function to add or update a To-Do item inside a particular account
  Future<void> addOrUpdateTodoForAccount({
    required String title,
  }) async {
    final activeUser = _userBox.get('active_user');
    print("active user :: $activeUser");

    // Ensure we are getting the correct type for user data
    final userData = _userBox.get(activeUser) as Map<String, dynamic>?;

    if (userData != null) {
      // If user data exists, add a To-Do list if not already present
      if (!userData.containsKey('listData')) {
        userData['listData'] =
            []; // Create an empty To-Do list if not already present
      }

      // Create a new To-Do item
      final listItem = {
        'name': title,
      };

      // Add the To-Do item to the list
      (userData['listData'] as List).add(listItem);

      // Save the updated data back to Hive
      await _userBox.put(activeUser, userData);
      print('To-Do item added/updated for UID: $activeUser');
    } else {
      // If user doesn't exist, create a new entry with the To-Do list
      final newUserData = {
        'listData': [
          {
            'name': title,
          }
        ],
      };

      await _userBox.put(activeUser, newUserData);
      print('New user data created for UID: $activeUser with To-Do');
    }
  }
}
