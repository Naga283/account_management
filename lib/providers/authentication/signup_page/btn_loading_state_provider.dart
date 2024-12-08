import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingStateProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
