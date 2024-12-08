import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/new/components/new_custom_drawer.dart';
import 'package:account_management/new/provider/active_data_provider.dart';
import 'package:account_management/new/services/local_storage_manager.dart';
import 'package:flutter/material.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final LocalAccountManager accountManager = LocalAccountManager();
  Map<String, dynamic>? activeAccountDetails;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addData(String name) async {
    final activeUid = accountManager.getActiveAccount();
    if (activeUid != null) {
      await accountManager.saveAccount(
          activeUid, activeAccountDetails?['email'], 'secure_password', {
        ...activeAccountDetails!,
        'new_field': 'New Data Added',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountManager = LocalAccountManager();
    final activeAccountNotifier = ActiveAccountNotifier(accountManager);
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: NewCustomDrawer(
        activeAccountNotifier: activeAccountNotifier,
      ),
      body: ValueListenableBuilder(
          valueListenable: activeAccountNotifier,
          builder: (context, data, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Account: ${data?['email'] ?? "None"}'),
                  SizedBox(height: 10),
                  // Text('Details: ${data ?? "No data"}'),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: data?["listData"].length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(data?["listData"][index]["name"]),
                          ),
                        );
                      })
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await activeAccountNotifier.accountManager.saveAccount(
                  //       data?['uid'],
                  //       data?['email'],
                  //       'secure_password',
                  //       {...data ?? {}, 'new_field': 'New Data'},
                  //     );
                  //     activeAccountNotifier.refresh();
                  //   },
                  //   child: Text('Add Data to Active Account'),
                  // ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add"),
                  content: TextFormField(
                    controller: nameController,
                  ),
                  actions: [
                    ExpandedElevatedBtn(
                        btnName: "Add",
                        onTap: () {
                          accountManager.addOrUpdateTodoForAccount(
                              title: nameController.text);
                          activeAccountNotifier.refresh();
                          nameController.clear();
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
