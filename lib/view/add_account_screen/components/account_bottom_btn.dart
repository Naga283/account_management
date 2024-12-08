import 'dart:io';

import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/services/account_crud/add_account_details.dart';
import 'package:account_management/services/account_crud/update_acount_details.dart';
import 'package:account_management/view/add_account_screen/add_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountBottomBtn extends ConsumerWidget {
  const AccountBottomBtn({
    super.key,
    required this.widget,
    required File? image,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.reeneterPasswordController,
    required this.mobileNoController,
  }) : _image = image;

  final AddOrEditAccountScreen widget;
  final File? _image;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController reeneterPasswordController;
  final TextEditingController mobileNoController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingStateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: ExpandedElevatedBtn(
        isLoading: isLoading,
        btnName: widget.getAccountDetails != null ? "Update" : "Add",
        onTap: () async {
          if (_image == null) {
            scaffoldMessage(context, "Please select Image!");
          } else {
            if (formKey.currentState?.validate() ?? false) {
              if (widget.getAccountDetails != null) {
                await updateAccountDetails(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  emailId: emailController.text,
                  password: reeneterPasswordController.text,
                  mobileNo: mobileNoController.text,
                  image: _image,
                  ref: ref,
                  context: context,
                  docId: widget.getAccountDetails?.accId ?? "",
                );
              } else {
                await addAccountDetails(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  emailId: emailController.text,
                  password: reeneterPasswordController.text,
                  mobileNo: mobileNoController.text,
                  image: _image,
                  ref: ref,
                  context: context,
                );
              }
            }
          }
        },
      ),
    );
  }
}
