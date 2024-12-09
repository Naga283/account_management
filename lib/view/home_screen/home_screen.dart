// ignore_for_file: deprecated_member_use

import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/view/home_screen/custom_drawer.dart';
import 'package:account_management/providers/active_data_provider.dart';
import 'package:account_management/services/account_manager/local_storage_manager.dart';
import 'package:account_management/view/home_screen/components/home_screen_card.dart';
import 'package:account_management/view/home_screen/components/pop_up_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final LocalAccountManager accountManager = LocalAccountManager();
  Map<String, dynamic>? activeAccountDetails;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController updateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountManager = LocalAccountManager();
    final activeAccountNotifier = ActiveAccountNotifier(accountManager);
    return WillPopScope(
      onWillPop: () async {
        final exit = await popUpMethod(context);

        return exit ?? false; // Return true to exit, false to stay
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
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
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: data?["listData"].length,
                        itemBuilder: (context, index) {
                          return HomeScreenCard(
                            updateController: updateController,
                            accountManager: accountManager,
                            activeAccountNotifier: activeAccountNotifier,
                            index: index,
                            name: data?["listData"][index]['name'],
                          );
                        })
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
                    title: const Text("Add"),
                    content: TextFormField(
                      controller: nameController,
                    ),
                    actions: [
                      ExpandedElevatedBtn(
                          btnName: "Add",
                          onTap: () {
                            accountManager.addNameValue(
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
      ),
    );
  }
}
