import 'package:account_management/common/am_textformfield.dart';
import 'package:account_management/providers/authentication/signup_page/is_password_visible_state_provider.dart';
import 'package:account_management/utils/validations.dart';
import 'package:account_management/view/authentication/password_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTextFormFields extends ConsumerWidget {
  const AccountTextFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileNoController,
    required this.isPasswordVisible,
    required this.passwordController,
    required this.reeneterPasswordController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController mobileNoController;
  final IsPasswordVisibleStateProvider isPasswordVisible;
  final TextEditingController passwordController;
  final TextEditingController reeneterPasswordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AmTextFormField(
          hintText: "First Name",
          textEditingController: firstNameController,
          validator: validateName,
        ),
        AmTextFormField(
          hintText: "Last Name",
          textEditingController: lastNameController,
          validator: validateName,
        ),
        AmTextFormField(
          hintText: "Email",
          textEditingController: emailController,
          validator: validateEmail,
        ),
        AmTextFormField(
          hintText: "Mobile No.",
          maxLength: 10,
          keyboardType: TextInputType.phone,
          validator: validateMobileNumber,
          textEditingController: mobileNoController,
        ),
        PasswordTextFormField(
            isPasswordVisible: !isPasswordVisible.isPasswordVisible,
            passwordController: passwordController,
            validator: validatePassword,
            onTap: () {
              ref.read(isPasswordVisibleStateProvider.notifier).state =
                  IsPasswordVisibleStateProvider(
                isPasswordVisible: !isPasswordVisible.isPasswordVisible,
                isReeneterPasswordVisible:
                    isPasswordVisible.isReeneterPasswordVisible,
              );
            }),
        PasswordTextFormField(
          isPasswordVisible: !isPasswordVisible.isReeneterPasswordVisible,
          passwordController: reeneterPasswordController,
          validator: (confirmPass) =>
              validateReEnterPassword(confirmPass, passwordController.text),
          onTap: () {
            ref.read(isPasswordVisibleStateProvider.notifier).state =
                IsPasswordVisibleStateProvider(
              isPasswordVisible: isPasswordVisible.isPasswordVisible,
              isReeneterPasswordVisible:
                  !isPasswordVisible.isReeneterPasswordVisible,
            );
          },
        ),
      ],
    );
  }
}
