import 'package:account_management/common/expanded_btn.dart';
import 'package:flutter/material.dart';

Future<dynamic> amDailog(BuildContext context, String title, String content1,
    String content2, Function() onYesTap,
    {Function()? onTapNo}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: RichText(
            text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
                text: content1,
                children: [
              TextSpan(
                  text: "$content2 ?",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
            ])),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ExpandedElevatedBtn(
            btnWidth: MediaQuery.of(context).size.width * 0.2,
            btnName: "Yes",
            onTap: onYesTap,
            bgCol: Colors.red,
          ),
          ExpandedElevatedBtn(
            btnWidth: MediaQuery.of(context).size.width * 0.2,
            btnName: "No",
            bgCol: Colors.green,
            onTap: onTapNo ??
                () {
                  Navigator.of(context).pop(); // Close the dialog
                },
          ),
        ],
      );
    },
  );
}
