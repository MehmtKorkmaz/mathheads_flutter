import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_mathematicians/helpers/consts.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/services/firestore_service.dart';
import 'package:social_mathematicians/widgets/appbar_logo.dart';
import 'package:social_mathematicians/widgets/post_card.dart';

import '../../model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends Const<HomePage> {
  AuthService authService = Get.put(AuthService());

  TextEditingController commentController = TextEditingController();
  FireStoreService fireStoreService = Get.put(FireStoreService());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel currentUser;
  getCurrentUser() async {
    currentUser = await fireStoreService.getUserModel(_auth.currentUser!.uid);
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void signOut() {
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: signOut, child: const AppbarLogo()),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/lottie/loading_lottie.json'),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var post = PostModel.fromSnap(snapshot.data!.docs[index]);
                  return PostCard(post: post);
                });
          }),
    );
  }
}
