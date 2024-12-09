import 'package:account_management/common/constants/hive_box_name.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> updateName({
  required String newTitle,
  required int index,
}) async {
  final Box userBox = Hive.box(commonBox);
  final activeUser = userBox.get('active_user');
  debugPrint("active user :: $activeUser");

  final userData = userBox.get(activeUser);

  if (userData != null) {
    if (userData.containsKey('listData') && userData['listData'] is List) {
      List listData = userData['listData'] as List;

      // Check if the index is valid
      if (index >= 0 && index < listData.length) {
        // Update the title of the To-Do item at the given index
        listData[index]['name'] = newTitle;

        await userBox.put(activeUser, userData);
        debugPrint('To-Do item updated for UID: $activeUser');
      } else {
        debugPrint('Invalid index: $index');
      }
    } else {
      debugPrint('No To-Do data found for UID: $activeUser');
    }
  } else {
    debugPrint('User data not found for UID: $activeUser');
  }
}
