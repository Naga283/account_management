import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final addedImagesProvider = StateProvider.autoDispose<Map<String, File>>((ref) {
//   return {};
// });

class AddImageChangeNotifier extends ChangeNotifier {
  Map<String, File> images = {};

  void addOrUpdateImage(String key, File file) {
    images[key] = file;
    notifyListeners();
  }

  void clear() {
    images.clear();
    notifyListeners();
  }
}

final addImageChangeNotifierProvider =
    ChangeNotifierProvider.autoDispose<AddImageChangeNotifier>(
        (ref) => AddImageChangeNotifier());
