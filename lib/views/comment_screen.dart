import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_mathematicians/model/post_model.dart';

import '../model/comment_model.dart';
import '../services/firestore_service.dart';
import '../widgets/my_button.dart';
import '../widgets/my_textfield.dart';

class CommentScreen extends StatefulWidget {
  final PostModel post;
  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  FireStoreService fireStoreService = Get.put(FireStoreService());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendComment() {
    fireStoreService.postComment(commentController.text, widget.post.postId);
    setState(() {
      commentController.clear();
    });
  }

  void deleteComment(String commentId) {
    fireStoreService.deleteComment(widget.post.postId, commentId);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: context.height * (0.72),
        width: context.width * (0.9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white.withOpacity(0.95),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'commentHeader'.tr,
                  style: context.theme.textTheme.headlineSmall,
                ),
              ),
              Container(
                  height: context.height * (0.46),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(25)),
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('posts')
                        .doc(widget.post.postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('error');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              Lottie.asset('assets/lottie/loading_lottie.json'),
                        );
                      }
                      PostModel post = PostModel.fromSnap(
                          snapshot.data as DocumentSnapshot<Object?>);

                      if (post.comments.isEmpty) {
                        return Center(child: Text('noComment'.tr));
                      } else {
                        return ListView.builder(
                            itemCount: post.comments.length,
                            itemBuilder: ((context, index) {
                              CommentModel comment =
                                  CommentModel.fromjson(post.comments[index]);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(comment.photoUrl),
                                ),
                                title: Text(
                                  comment.userName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(comment.comment),
                                trailing: (comment.uid ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? GestureDetector(
                                        onTap: () {
                                          deleteComment(comment.commentId);
                                        },
                                        child: const Icon(Icons.cancel))
                                    : Container(),
                              );
                            }));
                      }
                    },
                  )),
              MyTextfield(
                  controller: commentController,
                  hintText: 'commentHint'.tr,
                  isObscured: false,
                  icon: const Icon(
                    Icons.message,
                    color: Colors.black87,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MyButton(
                  buttonText: 'send'.tr,
                  onTap: sendComment,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
