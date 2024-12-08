import 'package:account_management/services/account_manager/account_manager.dart';
import 'package:account_management/view/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? activeEmail;
  String? activeUid;
  String? activePass;
  Map<String, String> allAccounts = {};

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  // Load accounts and set active account
  Future<void> _loadAccounts() async {
    String? uid = await AccountManager().getActiveAccount();
    if (uid != null) {
      Map<String, String> accounts = await AccountManager().getAllAccounts();
      setState(() {
        activeUid = uid;
        activeEmail = accounts[uid];
        allAccounts = accounts;
        activePass = accounts["${uid}_pass"];
      });
    }
  }

  // Switch account
  Future<void> _switchAccount(String uid, String pass) async {
    await AccountManager().setActiveAccount(uid);
    await FirebaseAuth.instance.signOut();

    String? email = allAccounts[uid];
    String? password = allAccounts['${uid}_pass'];
    if (email != null && password != null) {
      print("Pass :: ${password} adn email :: ${email}");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to account: $email')),
      );
    }

    setState(() {
      activeUid = uid;
      activeEmail = email;
      activePass = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
                "User Name"), // Replace with actual user name if available
            accountEmail: Text(activeEmail ?? "No Active Account"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                activeEmail != null ? activeEmail![0].toUpperCase() : "?",
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: allAccounts.entries.map((entry) {
                bool isActive = entry.key == activeUid;
                return ListTile(
                  leading: Icon(
                    isActive ? Icons.check_circle : Icons.account_circle,
                    color: isActive ? Colors.green : null,
                  ),
                  title: Text(entry.value),
                  subtitle: Text(entry.key),
                  onTap: isActive
                      ? null
                      : () async {
                          await _switchAccount(entry.key, "");
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
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signed Out")),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
