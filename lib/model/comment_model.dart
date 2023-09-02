class CommentModel {
  final String comment;
  final String uid;
  final String commentId;
  final datePublished;
  final String photoUrl;
  final String userName;

  CommentModel(
      {required this.comment,
      required this.uid,
      required this.commentId,
      required this.datePublished,
      required this.photoUrl,
      required this.userName});

  static Map<String, dynamic> toJson(CommentModel comment) {
    Map<String, dynamic> commentAsMap = {
      'comment': comment.comment,
      'uid': comment.uid,
      'commentId': comment.commentId,
      'datePublished': comment.datePublished,
      'photoUrl': comment.photoUrl,
      'userName': comment.userName
    };

    return commentAsMap;
  }

  factory CommentModel.fromjson(Map json) {
    CommentModel comment = CommentModel(
        comment: json['comment'],
        uid: json['uid'],
        commentId: json['commentId'],
        datePublished: json['datePublished'],
        photoUrl: json['photoUrl'],
        userName: json['userName']);

    return comment;
  }
}
