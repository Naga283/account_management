import 'package:account_management/common/constants/hive_box_name.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> deleteName({
  required int index,
}) async {
  final Box userBox = Hive.box(commonBox);
  final activeUser = userBox.get('active_user');
  debugPrint("Active User: $activeUser");

  final userData = userBox.get(activeUser);

  if (userData != null && userData is Map) {
    if (userData.containsKey('listData') && userData['listData'] is List) {
      List listData = userData['listData'] as List;

      if (index >= 0 && index < listData.length) {
        listData.removeAt(index);

        // Save updated user data back to Hive
        await userBox.put(activeUser, userData);
        debugPrint('To-Do item deleted for user: $activeUser');
      } else {
        debugPrint('Invalid index: $index');
      }
    } else {
      debugPrint('No To-Do list found for user: $activeUser');
    }
  } else {
    debugPrint('User data not found for user: $activeUser');
  }
}
