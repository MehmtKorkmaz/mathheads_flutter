import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String photoUrl;
  final String name;
  final String description;
  final List followers;
  final List follows;
  final List posts;

  UserModel({
    required this.userId,
    required this.email,
    required this.photoUrl,
    required this.name,
    required this.description,
    required this.followers,
    required this.follows,
    required this.posts,
  });

  static Map<String, dynamic> toJson(UserModel user) {
    Map<String, dynamic> userAsMap = {
      'userId': user.userId,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'name': user.name,
      'description': user.description,
      'followers': user.followers,
      'posts': user.posts
    };
    return userAsMap;
  }

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snap['userId'],
      email: snap['email'],
      photoUrl: snap['photoUrl'],
      name: snap['name'],
      description: snap['description'],
      followers: snap['followers'] ?? [],
      follows: snap['follows'] ?? [],
      posts: snap['posts'] ?? [],
    );
  }

  factory UserModel.fromjson(Map json) {
    UserModel user = UserModel(
      userId: json['userId'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      name: json['name'],
      description: json['description'] ?? '',
      followers: json['followers'] ?? [],
      follows: json['follows'] ?? [],
      posts: json['posts'] ?? [],
    );
    return user;
  }
}
