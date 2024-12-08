import 'dart:io';

import 'package:account_management/common/am_textformfield.dart';
import 'package:account_management/new/services/login_fun.dart';
import 'package:account_management/providers/authentication/profile_pic_state_provider.dart';
import 'package:account_management/providers/authentication/signup_page/is_password_visible_state_provider.dart';
import 'package:account_management/utils/validations.dart';
import 'package:account_management/view/authentication/login_page.dart';
import 'package:account_management/view/authentication/password_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationPageBody extends ConsumerWidget {
  const RegistrationPageBody({
    super.key,
    required GlobalKey<FormState> formKey,
    // required this.profilePic,
    required this.firstNameController,
    required this.lastNameController,
    required this.mobileNoController,
    required this.emailController,
    required this.isPasswordVisible,
    required this.passwordController,
    required this.isReenterpasswordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  // final File? profilePic;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController mobileNoController;
  final TextEditingController emailController;
  final IsPasswordVisibleStateProvider isPasswordVisible;
  final TextEditingController passwordController;
  final TextEditingController isReenterpasswordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePic = ref.watch(profilePicStateProvider);
    const sizedBox = SizedBox(
      height: 10,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const IconWithHeadingAndSubHeading(heading: "Sign Up"),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profilePic != null
                        ? FileImage(
                            profilePic,
                          )
                        : null,
                    child: profilePic == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                  TextButton(
                      onPressed: () async {
                        await pickProfilePicture(ref);
                      },
                      child: Text("Profile Pic")),
                  AmTextFormField(
                    hintText: "First name",
                    validator: (v) => validateName(v),
                    textEditingController: firstNameController,
                  ),
                  sizedBox,
                  AmTextFormField(
                    hintText: "Last name",
                    validator: (v) => validateName(v),
                    textEditingController: lastNameController,
                  ),
                  sizedBox,
                  AmTextFormField(
                    hintText: "Mobile Number",
                    validator: (v) => validateMobileNumber(v),
                    textEditingController: mobileNoController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                  ),
                  sizedBox,
                  AmTextFormField(
                    hintText: "Your e-mail",
                    validator: (v) => validateEmail(v),
                    textEditingController: emailController,
                  ),
                  sizedBox,
                  PasswordTextFormField(
                      isPasswordVisible: isPasswordVisible.isPasswordVisible,
                      passwordController: passwordController,
                      validator: validatePassword,
                      onTap: () {
                        ref
                                .read(isPasswordVisibleStateProvider.notifier)
                                .state =
                            IsPasswordVisibleStateProvider(
                                isPasswordVisible:
                                    !isPasswordVisible.isPasswordVisible,
                                isReeneterPasswordVisible: isPasswordVisible
                                    .isReeneterPasswordVisible);
                      }),
                  PasswordTextFormField(
                      isPasswordVisible:
                          isPasswordVisible.isReeneterPasswordVisible,
                      passwordController: isReenterpasswordController,
                      validator: (reEnterPass) => validateReEnterPassword(
                          reEnterPass, passwordController.text),
                      hintText: "Re-enter Password",
                      onTap: () {
                        ref
                            .read(isPasswordVisibleStateProvider.notifier)
                            .state = IsPasswordVisibleStateProvider(
                          isPasswordVisible:
                              isPasswordVisible.isPasswordVisible,
                          isReeneterPasswordVisible:
                              !isPasswordVisible.isReeneterPasswordVisible,
                        );
                      }),
                ],
              ),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (builder) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              child: const Text(
                "Already Have an account?",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
