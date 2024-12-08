import 'package:flutter_riverpod/flutter_riverpod.dart';

final isPasswordVisibleStateProvider =
    StateProvider.autoDispose<IsPasswordVisibleStateProvider>((ref) {
  return IsPasswordVisibleStateProvider();
});

class IsPasswordVisibleStateProvider {
  final bool isPasswordVisible;
  final bool isReeneterPasswordVisible;

  IsPasswordVisibleStateProvider(
      {this.isPasswordVisible = false, this.isReeneterPasswordVisible = false});
}
