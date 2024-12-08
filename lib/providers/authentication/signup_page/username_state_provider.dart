import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNameStateProvider = StateProvider.autoDispose<String>((ref) {
  return "N/A";
});
