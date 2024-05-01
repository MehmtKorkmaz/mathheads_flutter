import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String uid;
  final String description;
  final String userName;
  final String profileImage;
  final List postPhotoUrl;
  final datePublished;
  final List likes;
  final String type;
  final List comments;

  PostModel({
    required this.postId,
    required this.uid,
    required this.description,
    required this.userName,
    required this.profileImage,
    required this.postPhotoUrl,
    required this.datePublished,
    required this.likes,
    required this.type,
    required this.comments,
  });

  factory PostModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        type: snapshot['type'],
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        userName: snapshot["userName"],
        postPhotoUrl: snapshot['postPhotoUrl'],
        profileImage: snapshot['profileImage'],
        comments: snapshot['comments'] ?? []);
  }

  static Map<String, dynamic> toJson(PostModel post) {
    Map<String, dynamic> postAsMap = {
      'type': post.type,
      "description": post.description,
      "uid": post.uid,
      "likes": post.likes,
      "userName": post.userName,
      "postId": post.postId,
      "datePublished": post.datePublished,
      'postPhotoUrl': post.postPhotoUrl,
      'profileImage': post.profileImage,
      'comments': post.comments
    };
    return postAsMap;
  }
}
