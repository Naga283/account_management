import 'package:account_management/common/am_dailog.dart';
import 'package:account_management/common/scaffold_message.dart';
import 'package:account_management/providers/active_data_provider.dart';
import 'package:account_management/services/account_manager/local_storage_manager.dart';
import 'package:account_management/splash_screen.dart';
import 'package:account_management/utils/colors.dart';
import 'package:account_management/view/authentication/login_page.dart';
import 'package:account_management/view/home_screen/components/customer_drawer_body.dart';
import 'package:flutter/material.dart';

class NewCustomDrawer extends StatefulWidget {
  final ActiveAccountNotifier activeAccountNotifier;

  const NewCustomDrawer({super.key, required this.activeAccountNotifier});
  @override
  State createState() => _NewCustomDrawerState();
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
    var copyWith = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: appColors.whiteColor,
          fontSize: 14,
        );
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(color: appColors.primary),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
                left: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomDrawerBody(
                    activeAccount: activeAccount,
                    copyWith: copyWith,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: widget.activeAccountNotifier.accountManager
                  .getAllUsers()
                  .map((uid) {
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
                          scaffoldMessage(
                              context, "Account Successfully Changed!");
                          Navigator.pop(context);
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
              await amDailog(context, "Are You Sure", "You want to logout", "",
                  () async {
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
              });
            },
          ),
        ],
      ),
    );
  }
}
