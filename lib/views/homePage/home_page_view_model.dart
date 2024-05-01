import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_mathematicians/model/user_model.dart';
import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/services/firestore_service.dart';

mixin HomePageViewModel {
  AuthService authService = Get.put(AuthService());

  FireStoreService fireStoreService = Get.put(FireStoreService());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late UserModel currentUser;

  getCurrentUser() async {
    currentUser = await fireStoreService.getUserModel(_auth.currentUser!.uid);
  }

  void signOut() {
    authService.signOut();
  }
}
