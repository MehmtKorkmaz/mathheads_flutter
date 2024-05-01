import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:social_mathematicians/model/user_model.dart';
import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/services/firestore_service.dart';
import 'package:social_mathematicians/widgets/appbar_logo.dart';

import '../../widgets/hero_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FireStoreService fireStoreService = Get.put(FireStoreService());

  late UserModel currentUser;

  bool isFollow = false;

  getCurrentUser() async {
    currentUser = await fireStoreService.getUserModel(_auth.currentUser!.uid);
    if (currentUser.follows.contains(widget.uid)) {
      isFollow = true;
    } else {
      isFollow = false;
    }
  }

  void followUser() async {
    fireStoreService.followUser(widget.uid);
    isFollow = !isFollow;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  AuthService auth = Get.put(AuthService());
  void signOut() {
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          (widget.uid == _auth.currentUser!.uid)
              ? Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.logout)),
                )
              : Container()
        ],
        title: GestureDetector(onTap: signOut, child: const AppbarLogo()),
      ),
      body: FutureBuilder(
          future: _firestore.collection('users').doc(widget.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/lottie/loading_lottie.json'),
              );
            }

            UserModel user = UserModel.fromSnapshot(snapshot.requireData);

            return Stack(
              children: [
                (currentUser.userId != widget.uid)
                    ? Align(
                        alignment: const Alignment(0.15, -1),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: followUser,
                            child: Card(
                              color: Colors.black87,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 5),
                                child: Text(
                                  !isFollow ? 'follow'.tr : 'unfollow'.tr,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: const ShapeDecoration(
                                    color: Colors.white,
                                    shape: OvalBorder(
                                      side: BorderSide(
                                          width: 1.50,
                                          color: Color(0xFFFA9884)),
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(user.photoUrl),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: Text(
                                    user.name,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('posts'.tr),
                                Text(
                                  user.posts.length.toString(),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('followers'.tr),
                                Text(
                                  user.followers.length.toString(),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('follows'.tr),
                                Text(
                                  user.follows.length.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          ' ° ${user.description}',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                          height: context.height * (0.5),
                          width: context.width * (1),
                          child: _buildUserPosts(user.posts))
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildUserPosts(List userPosts) {
    if (userPosts.isEmpty) {
      return Center(child: Text('noPost'.tr));
    }
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: userPosts.length,
        itemBuilder: ((context, index) => FutureBuilder(
            future: _firestore.collection('posts').doc(userPosts[index]).get(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return const Text('error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset('assets/lottie/loading_lottie.json'),
                );
              }

              PostModel post = PostModel.fromSnap(snapshot.data!);

              return GestureDetector(
                onTap: () {
                  Get.to(() => HeroPage(
                        post: post,
                      ));
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(post.postPhotoUrl[0]),
                        fit: BoxFit.cover),
                  ),
                ),
              );
            }))));
  }
}
