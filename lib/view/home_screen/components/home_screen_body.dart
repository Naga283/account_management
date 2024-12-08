import 'dart:io';

import 'package:account_management/common/am_dailog.dart';
import 'package:account_management/modals/get_account_details.dart';
import 'package:account_management/providers/added_images_state_provider.dart';
import 'package:account_management/services/account_crud/delete_account.dart';
import 'package:account_management/view/add_account_screen/add_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenBody extends ConsumerWidget {
  const HomeScreenBody({
    super.key,
    required this.images,
    required this.accDet,
  });

  final AddImageChangeNotifier images;
  final List<GetAccountDetails> accDet;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: accDet.isEmpty
            ? Center(
                child: Text(
                  "No Data",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accDet.length,
                    itemBuilder: (context, index) {
                      String docId = accDet[index].accId;
                      File? imageFile = images.images[docId];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                              right: 20, top: 10, bottom: 10),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: imageFile != null
                                ? FileImage(
                                    imageFile,
                                  )
                                : null,
                            child: imageFile == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[600],
                                  )
                                : null,
                          ),
                          title: Text(accDet[index].firstName),
                          subtitle: Text("P.n : ${accDet[index].mobileNo}"),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AddOrEditAccountScreen(
                                            getAccountDetails: accDet[index],
                                            imageFile: imageFile,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await amDailog(
                                      context,
                                      "Are You Sure",
                                      "You want to delete ",
                                      accDet[index].firstName, () async {
                                    await deleteAccountDetails(
                                      accountId: accDet[index].accId,
                                      ref: ref,
                                      context: context,
                                    );
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
