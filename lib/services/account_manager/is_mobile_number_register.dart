// Function to check if a mobile number is already registered
import 'package:account_management/common/constants/hive_box_name.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isMobileRegistered(String mobileNumber) {
  final Box userBox = Hive.box(commonBox);
  // Retrieve all accounts
  final accounts = userBox.toMap();

  // Check if any account has the same mobile number
  final isRegistered = accounts.values.any((userData) {
    if (userData is Map<String, dynamic>) {
      return userData['mobile_no'] == mobileNumber;
    }
    return false;
  });

  return isRegistered;
}
