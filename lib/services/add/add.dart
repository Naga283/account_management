import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addDataToFirestore(String name) async {
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("No user logged in.");
    return; // Early return if there's no user logged in
  }

  try {
    // Reference to Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection("todo");

    // Add data to Firestore
    await collection.doc(user.uid).set({"name": name},
        SetOptions(merge: true)); // Merge ensures no overwriting

    print("Data added for user ${user.uid}");
  } catch (e) {
    print("Error adding data: $e");
  }
}
