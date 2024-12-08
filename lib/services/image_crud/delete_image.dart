// Delete the image
import 'dart:io';

import 'package:account_management/providers/added_images_state_provider.dart';
import 'package:account_management/services/image_crud/image_operations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> deleteImage(String docId) async {
  await LocalImageStorage().deleteImage(docId);
}

Future<void> storeImage(File? image, String docId, WidgetRef ref) async {
  if (image != null) {
    ref.read(addImageChangeNotifierProvider).addOrUpdateImage(docId, image);
    await LocalImageStorage().storeImage(image, docId, ref);
  }
}

// Get the stored image path
Future<File?> getStoredImage(String docId, Ref ref) async {
  String? imagePath = await LocalImageStorage().getImagePath(docId);
  print("image path :: ${imagePath}");
  if (imagePath != null) {
    ref
        .read(addImageChangeNotifierProvider)
        .addOrUpdateImage(docId, File(imagePath));
    return File(imagePath);
  }
  return null;
}

// Update the image with a new one
Future<void> updateImage(
    File? profileImage, String docId, WidgetRef ref) async {
  if (profileImage != null) {
    await deleteImage(docId);
    ref
        .read(addImageChangeNotifierProvider)
        .addOrUpdateImage(docId, profileImage);
    await LocalImageStorage().updateImage(profileImage, docId, ref);
    print('Image updated successfully.');
  }
}
