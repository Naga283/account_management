import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePicStateProvider = StateProvider.autoDispose<File?>((ref) {
  return;
});
