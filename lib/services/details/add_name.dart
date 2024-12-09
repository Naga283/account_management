// Function to add or update a To-Do item inside a particular account
import 'package:account_management/common/constants/hive_box_name.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> addName({
  required String title,
}) async {
  final Box userBox = Hive.box(commonBox);
  final activeUser = userBox.get('active_user');
  print("active user :: $activeUser");

  final userData = userBox.get(activeUser);

  if (userData != null && userData is Map) {
    if (!userData.containsKey('listData')) {
      userData['listData'] = <Map<String, dynamic>>[];
    }

    final listItem = {
      'name': title,
    };
    List listData = userData['listData'] as List;
    // Add the To-Do item to the list
    listData.add(listItem);

    await userBox.put(activeUser, userData);
    debugPrint('To-Do item added/updated for UID: $activeUser');
  } else {
    final newUserData = {
      'listData': [
        {
          'name': title,
        }
      ],
    };

    await userBox.put(activeUser, newUserData);
    debugPrint('New user data created for UID: $activeUser with To-Do');
  }
}
