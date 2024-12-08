import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/new/components/view/registration_page.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:account_management/new/services/login_fun.dart';
import 'package:account_management/providers/authentication/login_page/is_login_password_visible_state_provider.dart';
import 'package:account_management/providers/authentication/signup_page/btn_loading_state_provider.dart';
import 'package:account_management/services/firebase_authentication_services.dart';
import 'package:account_management/utils/colors.dart';
import 'package:account_management/utils/validations.dart';
import 'package:account_management/common/am_textformfield.dart';
import 'package:account_management/view/authentication/login_with_heading.dart';
import 'package:account_management/view/authentication/password_textform_field.dart';
import 'package:account_management/view/authentication/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingStateProvider);
    final isPasswordVisible = ref.watch(isLoginPasswordVisibleStateProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.whiteColor.withOpacity(0.4),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const IconWithHeadingAndSubHeading(
              heading: 'Login',
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  AmTextFormField(
                    hintText: 'Your e-mail',
                    textEditingController: emailController,
                    validator: validateEmail,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PasswordTextFormField(
                    isPasswordVisible: isPasswordVisible,
                    passwordController: passwordController,
                    // errorText: ref.watch(errorTextFormProvider),
                    onTap: () {
                      ref
                          .read(isLoginPasswordVisibleStateProvider.notifier)
                          .state = !isPasswordVisible;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (builder) {
                          return const RegisterPage();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16,
          right: 16,
        ),
        child: ExpandedElevatedBtn(
          btnName: "Login",
          isLoading: isLoading,
          onTap: () async {
            if (_formKey.currentState?.validate() ?? false) {
              await login(
                  emailController.text, passwordController.text, context);
              // await loginWithEmailAndPassword(
              //   emailController.text,
              //   passwordController.text,
              //   context,
              //   ref,
              // );
            }
          },
        ),
      ),
    );
  }
}
