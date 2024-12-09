import 'dart:io';

import 'package:account_management/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomDrawerBody extends StatelessWidget {
  const CustomDrawerBody({
    super.key,
    required this.activeAccount,
    required this.copyWith,
  });

  final Map<String, dynamic>? activeAccount;
  final TextStyle? copyWith;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: activeAccount?['profilePic'] != null
                  ? FileImage(
                      File(activeAccount!['profilePic'])) // Show local file
                  : null,
              child: activeAccount?['profilePic'] == null
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    )
                  : null,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeAccount?['first_name'] +
                          " " +
                          activeAccount?['last_name'] ??
                      'No Name',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appColors.whiteColor,
                        fontSize: 20,
                      ),
                ),
                Text(
                  "Mobile : ${activeAccount?['mobile_no']}",
                  style: copyWith,
                ),
                Text(
                  "Email : ${activeAccount?['email']}",
                  style: copyWith,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
