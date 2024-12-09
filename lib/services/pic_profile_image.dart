//Pic
import 'dart:io';

import 'package:account_management/providers/authentication/profile_pic_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickProfilePicture(WidgetRef ref) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    ref.read(profilePicStateProvider.notifier).state = File(pickedFile.path);
  }
}
