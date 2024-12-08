import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoginPasswordVisibleStateProvider =
    StateProvider.autoDispose<bool>((ref) {
  return false;
});
