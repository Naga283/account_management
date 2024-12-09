import 'package:account_management/common/am_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordTextFormField extends ConsumerWidget {
  const PasswordTextFormField({
    super.key,
    required this.isPasswordVisible,
    required this.passwordController,
    required this.onTap,
    this.errorText,
    this.hintText,
    this.validator,
  });

  final bool isPasswordVisible;
  final TextEditingController passwordController;
  final Function() onTap;
  final String? errorText;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AmTextFormField(
      hintText: hintText ?? 'Password',
      errorText: errorText,
      obscureText: isPasswordVisible,
      validator: validator,
      textEditingController: passwordController,
      suffixIcon: IconButton(
        onPressed: onTap,
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }
}
