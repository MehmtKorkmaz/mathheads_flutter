import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_mathematicians/model/comment_model.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';

class FireStoreService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getUserModel(String uid) async {
    var json = await _firestore.collection('users').doc(uid).get();
    UserModel user = UserModel.fromSnapshot(json);

    return user;
  }

  Future<PostModel> getPostModel(String postId) async {
    var json = await _firestore.collection('posts').doc(postId).get();

    PostModel post = PostModel.fromSnap(json);

    return post;
  }

  Future uploadPost(String description, String type, List postPhotoUrl) async {
    // create a unique post id
    String postId = const Uuid().v1();

    // get user details for post model

    UserModel user = await getUserModel(_auth.currentUser!.uid);

    // add post id to user's posts list
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'posts': FieldValue.arrayUnion([postId])
    });

    //create post model

    PostModel post = PostModel(
        postId: postId,
        uid: user.userId,
        description: description,
        userName: user.name,
        profileImage: user.photoUrl,
        postPhotoUrl: postPhotoUrl,
        datePublished: DateTime.now(),
        likes: [],
        type: type,
        comments: []);

    //add post to firestore
    await _firestore
        .collection('posts')
        .doc(postId)
        .set(PostModel.toJson(post));
  }

  Future deletePost(PostModel post) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'posts': FieldValue.arrayRemove([post.postId])
    });
  }

  Future postComment(String comment, String postId) async {
    // get user's info

    UserModel user = await getUserModel(_auth.currentUser!.uid);
    // get unique id for comment
    String commentId = const Uuid().v1();

    //create a new commentModel

    CommentModel commentPost = CommentModel(
        comment: comment,
        uid: user.userId,
        commentId: commentId,
        datePublished: DateTime.now(),
        photoUrl: user.photoUrl,
        userName: user.name);

    //add comment to commentlist

    _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([CommentModel.toJson(commentPost)])
    });
  }
  //Delete Comment

  Future deleteComment(String postId, String commentId) async {
    PostModel post = await getPostModel(postId);

    List commentList = post.comments;

    try {
      for (var comment in commentList) {
        if (commentId == comment['commentId']) {
          commentList.remove(comment);

          await _firestore
              .collection('posts')
              .doc(postId)
              .update({'comments': commentList});
        }
      }
    } catch (e) {
      Get.snackbar('Done!', 'Comment deleted.');
    }
  }

  Future<void> likePost(String postId) async {
    String uid = _auth.currentUser!.uid;

    PostModel post = await getPostModel(postId);

    List likeList = post.likes;
    if (likeList.contains(uid)) {
      //if like list contains curren user's uid remove from list
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      //if likelist is not contains user's uid add to list
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  //FOLLOW USER

  Future followUser(String uid) async {
    String currentUserId = _auth.currentUser!.uid;
    UserModel currentUser = await getUserModel(currentUserId);

    if (currentUser.follows.contains(uid)) {
      //if current user's follows list  contains other user's ıd remove
      _firestore.collection('users').doc(currentUserId).update({
        'follows': FieldValue.arrayRemove([uid])
      });

      _firestore.collection('users').doc(uid).update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });
    } else {
      //if current user's follows list not contains other user's ıd  add
      _firestore.collection('users').doc(currentUserId).update({
        'follows': FieldValue.arrayUnion([uid])
      });
      _firestore.collection('users').doc(uid).update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });
    }
  }
}
