import 'dart:io';

import 'package:account_management/new/provider/active_data_provider.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:account_management/splash_screen.dart';
import 'package:account_management/view/authentication/login_page.dart';
import 'package:flutter/material.dart';

class NewCustomDrawer extends StatefulWidget {
  final ActiveAccountNotifier activeAccountNotifier;

  const NewCustomDrawer({super.key, required this.activeAccountNotifier});
  @override
  _NewCustomDrawerState createState() => _NewCustomDrawerState();
}

class _NewCustomDrawerState extends State<NewCustomDrawer> {
  final LocalAccountManager accountManager = LocalAccountManager();
  String? activeUser;
  List<String> allUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeAccount = widget.activeAccountNotifier.value;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(activeAccount?['name'] ?? 'No Name'),
            accountEmail: Text(activeAccount?['email'] ?? 'No Email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: activeAccount?['profilePic'] != null
                  ? FileImage(
                      File(activeAccount!['profilePic'])) // Show local file
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
            ),
          ),
          Expanded(
            child: ListView(
              children: widget.activeAccountNotifier.accountManager
                  .getAllUsers()
                  .map((uid) {
                print("uid :: $uid");
                print("active :: ${activeAccount?['uid']}");
                bool isActive = uid == activeAccount?['uid'];
                return ListTile(
                  leading: Icon(
                    isActive ? Icons.check_circle : Icons.account_circle,
                    color: isActive ? Colors.green : null,
                  ),
                  title: Text(uid),
                  onTap: isActive
                      ? null
                      : () {
                          widget.activeAccountNotifier.switchAccount(uid);
                          Navigator.pop(context); // Close the drawer
                        },
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Account"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign Out"),
            onTap: () async {
              await accountManager.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return const SplashScreen();
                }),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signed Out")),
              );
            },
          ),
        ],
      ),
    );
  }
}
