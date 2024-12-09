import 'package:account_management/common/am_dailog.dart';
import 'package:account_management/common/am_textformfield.dart';
import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/providers/active_data_provider.dart';
import 'package:account_management/services/account_manager/local_storage_manager.dart';
import 'package:account_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({
    super.key,
    required this.updateController,
    required this.accountManager,
    required this.activeAccountNotifier,
    required this.index,
    required this.name,
  });

  final TextEditingController updateController;
  final LocalAccountManager accountManager;
  final ActiveAccountNotifier activeAccountNotifier;
  final String name;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async {
                  updateController.text = name;
                  await showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return PopScope(
                          onPopInvoked: (v) {
                            updateController.clear();
                          },
                          child: AlertDialog(
                            title: const Text("Edit"),
                            content: AmTextFormField(
                                hintText: "",
                                textEditingController: updateController),
                            actions: [
                              ExpandedElevatedBtn(
                                  btnName: "Edit",
                                  onTap: () {
                                    accountManager.updateNameValue(
                                        newTitle: updateController.text,
                                        index: index);
                                    Navigator.of(context).pop();
                                    activeAccountNotifier.refresh();
                                  })
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () async {
                await amDailog(
                    context, "Are You Sure", "You want to delete ", name,
                    () async {
                  await accountManager.deleteNameValue(index: index);
                  Navigator.of(context).pop();
                  activeAccountNotifier.refresh();
                });
              },
              icon: const Icon(Icons.delete),
              color: appColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
