import 'package:account_management/common/am_dailog.dart';
import 'package:account_management/common/expanded_btn.dart';
import 'package:account_management/notifiers/get_account_details_notifier.dart';
import 'package:account_management/providers/added_images_state_provider.dart';
import 'package:account_management/services/add/add.dart';
import 'package:account_management/services/firebase_authentication_services.dart';
import 'package:account_management/view/home_screen/components/home_screen_body.dart';
import 'package:account_management/view/home_screen/components/pop_up_method.dart';
import 'package:account_management/view/home_screen/customer_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getAccountDetails = ref.watch(getAccountDetailsFutureProvider);
    final images = ref.watch(addImageChangeNotifierProvider);

    return WillPopScope(
      onWillPop: () async {
        final exit = await popUpMethod(context);

        return exit ?? false; // Return true to exit, false to stay
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home Screen"),
          actions: [
            IconButton(
                onPressed: () async {
                  await amDailog(
                      context, "Are You Sure", "You want to logout", "",
                      () async {
                    await logoutUser(context, ref);
                  });
                },
                icon: const Icon(Icons.logout)),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: getAccountDetails.when(data: (accDet) {
          return HomeScreenBody(
            images: images,
            accDet: accDet,
          );
        }, error: (error, sT) {
          return const Text("error");
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
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
                          onTap: () async {
                            await addDataToFirestore(nameController.text);
                          })
                    ],
                  );
                });
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const AddOrEditAccountScreen(),
            //   ),
            // );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
