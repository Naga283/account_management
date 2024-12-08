import 'package:account_management/modals/get_account_details.dart';
import 'package:account_management/services/account_crud/get_account_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAccountDetailsFutureProvider =
    FutureProvider.autoDispose<List<GetAccountDetails>>((ref) async {
  try {
    return await getUserDetails(ref) ?? [];
  } catch (e, sT) {
    throw Exception();
  }
});
