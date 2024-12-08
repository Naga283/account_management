import 'package:account_management/modals/get_account_details.dart';
import 'package:account_management/providers/added_images_state_provider.dart';
import 'package:account_management/services/image_crud/delete_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<GetAccountDetails>?> getUserDetails(
  Ref ref,
) async {
  try {
    // Get current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in.");
      return null;
    }

    // Reference to the user's 'accounts' collection in Firestore
    CollectionReference accountsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts');

    // Fetch all account documents
    QuerySnapshot querySnapshot = await accountsRef.get();
    List<Map<String, dynamic>> accounts = querySnapshot.docs.map((doc) {
      return {
        "accountId": doc.id, // This is the accountId (document ID)
        ...doc.data() as Map<String, dynamic>
      };
    }).toList();

    List<GetAccountDetails> getaccountDetails = accounts
        .map((e) => GetAccountDetails.fromJson(e))
        .cast<GetAccountDetails>()
        .toList();

    ref.read(addImageChangeNotifierProvider).clear();
    for (int i = 0; i < getaccountDetails.length; i++) {
      await getStoredImage(getaccountDetails[i].accId, ref);
    }

    return getaccountDetails;
  } catch (e) {
    print("Error fetching user details: $e");
    return null;
  }
}
