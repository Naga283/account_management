import 'dart:io';
import 'package:account_management/modals/get_account_details.dart';
import 'package:account_management/providers/authentication/signup_page/is_password_visible_state_provider.dart';
import 'package:account_management/view/add_account_screen/components/account_bottom_btn.dart';
import 'package:account_management/view/add_account_screen/components/account_textformfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddOrEditAccountScreen extends ConsumerStatefulWidget {
  const AddOrEditAccountScreen({
    super.key,
    this.getAccountDetails,
    this.imageFile,
  });
  final GetAccountDetails? getAccountDetails;
  final File? imageFile;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddOrEditAccountScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController reeneterPasswordController = TextEditingController();

  File? _image;

  // Pick an image from gallery or take a photo
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source:
          ImageSource.gallery, // Change to ImageSource.camera to use the camera
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.getAccountDetails != null) {
      var getAccountDetails = widget.getAccountDetails;
      firstNameController =
          TextEditingController(text: getAccountDetails?.firstName);
      lastNameController =
          TextEditingController(text: getAccountDetails?.lastName);
      emailController = TextEditingController(text: getAccountDetails?.emailId);
      passwordController =
          TextEditingController(text: getAccountDetails?.password);
      mobileNoController =
          TextEditingController(text: getAccountDetails?.mobileNo);
      _image = widget.imageFile;
    }
  }

  @override
  Widget build(BuildContext context) {
// Pick an image.
    var sizedBox = const SizedBox(
      height: 40,
    );
    final isPasswordVisible = ref.watch(isPasswordVisibleStateProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.getAccountDetails != null ? "Update" : "Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null
                      ? FileImage(
                          _image!,
                        )
                      : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
                TextButton(
                    onPressed: () async {
                      await _pickImage();
                    },
                    child: Text(widget.getAccountDetails != null
                        ? "Update Pic"
                        : "Add Profile Pic")),
                sizedBox,
                AccountTextFormFields(
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  emailController: emailController,
                  mobileNoController: mobileNoController,
                  isPasswordVisible: isPasswordVisible,
                  passwordController: passwordController,
                  reeneterPasswordController: reeneterPasswordController,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AccountBottomBtn(
        widget: widget,
        image: _image,
        formKey: formKey,
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        emailController: emailController,
        reeneterPasswordController: reeneterPasswordController,
        mobileNoController: mobileNoController,
      ),
    );
  }
}
