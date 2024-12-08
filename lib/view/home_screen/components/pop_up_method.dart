import 'package:account_management/common/expanded_btn.dart';
import 'package:flutter/material.dart';

Future<dynamic> popUpMethod(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing dialog by tapping outside
    builder: (context) {
      return AlertDialog(
        title: const Text("Are you sure"),
        content: const Text("Do you want to exit?"),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ExpandedElevatedBtn(
            btnWidth: MediaQuery.of(context).size.width * 0.2,
            btnName: "Yes",
            bgCol: Colors.red,
            onTap: () {
              Navigator.of(context).pop(true); // Exit the app
            },
          ),
          ExpandedElevatedBtn(
            btnWidth: MediaQuery.of(context).size.width * 0.2,
            btnName: "No",
            bgCol: Colors.green,
            onTap: () {
              Navigator.of(context).pop(false); // Do not exit
            },
          ),
        ],
      );
    },
  );
}
