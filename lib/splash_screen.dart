import 'dart:async';
import 'package:account_management/new/components/new_home_screen.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:account_management/view/authentication/login_page.dart';
import 'package:account_management/view/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isLoggedIn = LocalAccountManager().getLoggedIn();
    timer = Timer.periodic(
        const Duration(seconds: 3),
        (v) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return !isLoggedIn ? const LoginPage() : NewHomeScreen();
                },
              ),
            ));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 25, 178, 238),
            Color.fromARGB(255, 21, 236, 229)
          ],
        )),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LottieBuilder.asset(
                  //   "assets/animations/02d.json",
                  //   height: 200,
                  //   width: 200,
                  // ),
                  Text(
                    "Account Management",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "v1.0.0",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
