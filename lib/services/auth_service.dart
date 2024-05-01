import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class AuthService extends GetxController {
  String defaultPhutuUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Gnome-stock_person.svg/800px-Gnome-stock_person.svg.png';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In
  Future singInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  // sign out
  signOut() async {
    await _firebaseAuth.signOut();
  }

  // create a user
  Future singUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      singInWithEmailAndPassword(email, password);
      Get.snackbar('Done!', 'You can login now');
      //after creating a new user create a new collection for the user information to database

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(UserModel.toJson(UserModel(
            userId: userCredential.user!.uid,
            email: email,
            name: name,
            photoUrl: defaultPhutuUrl,
            description: '',
            followers: [],
            follows: [],
            posts: [],
          )));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }
}
