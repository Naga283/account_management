import 'dart:io';
import 'package:account_management/providers/added_images_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalImageStorage {
  // Function to store image locally using UID and Document ID
  Future<void> storeImage(File image, String documentId, WidgetRef ref) async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      // Get the directory path to store the image
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Create a unique filename using the UID and document ID
      final fileName = '${user.uid}_$documentId.jpg';

      // Save the image in the local storage
      final file = File('$path/$fileName');
      await file.writeAsBytes(await image.readAsBytes());
      // ref.read(addedImagesProvider.notifier).state[documentId] = file;
      print('Image saved locally at: $path/$fileName');
    } catch (e) {
      print('Error storing image: $e');
    }
  }

  // Function to update the image
  Future<void> updateImage(
      File newImage, String documentId, WidgetRef ref) async {
    await storeImage(newImage, documentId, ref);
    print('Image updated successfully.');
  }

  // Function to delete the stored image
  Future<void> deleteImage(String documentId) async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      // Get the directory path to find the image
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Create the file path using UID and document ID
      final filePath = '$path/${user.uid}_$documentId.jpg';
      final file = File(filePath);

      // Check if the file exists and delete it
      if (await file.exists()) {
        await file.delete();
        print('Image deleted from local storage.');
      } else {
        print('No image found to delete.');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  // Function to get the image path
  Future<String?> getImagePath(String documentId) async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return null;
      }

      // Get the directory path to find the image
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Create the file path using UID and document ID
      final filePath = '$path/${user.uid}_$documentId.jpg';
      final file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        return filePath;
      } else {
        print('Image not found.');
        return null;
      }
    } catch (e) {
      print('Error fetching image path: $e');
      return null;
    }
  }
}
