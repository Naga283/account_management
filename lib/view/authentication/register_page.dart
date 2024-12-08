import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:account_management/new/services/login_fun.dart';
import 'package:account_management/providers/authentication/profile_pic_state_provider.dart';
import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/providers/authentication/signup_page/is_password_visible_state_provider.dart';
import 'package:account_management/utils/colors.dart';
import 'package:account_management/view/authentication/components/registration_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController isReenterpasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LocalAccountManager accountManager = LocalAccountManager();

  @override
  Widget build(BuildContext context) {
    final profilePic = ref.watch(profilePicStateProvider);
    final isPasswordVisible = ref.watch(isPasswordVisibleStateProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: appColors.whiteColor.withOpacity(0.4),
      ),
      body: RegistrationPageBody(
        formKey: _formKey,
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        mobileNoController: mobileNoController,
        emailController: emailController,
        isPasswordVisible: isPasswordVisible,
        passwordController: passwordController,
        isReenterpasswordController: isReenterpasswordController,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16,
          right: 16,
        ),
        child: ExpandedElevatedBtn(
          isLoading: ref.watch(isLoadingStateProvider),
          btnName: "Register",
          onTap: () async {
            if (_formKey.currentState?.validate() ?? false) {
              registerUser(
                emailVal: emailController.text,
                pass: passwordController.text,
                profilPic: profilePic,
                context: context,
                accountManager: accountManager,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                mobileNumber: mobileNoController.text,
              );
            }
          },
        ),
      ),
    );
  }
}
