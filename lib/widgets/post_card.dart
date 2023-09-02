import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_mathematicians/helpers/consts.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:social_mathematicians/services/firestore_service.dart';
import 'package:social_mathematicians/views/comment_screen.dart';
import 'package:social_mathematicians/views/profile/profile_page.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends Const<PostCard> {
  PageController photoController = PageController();

  bool isLiked = false;
  TextEditingController commentController = TextEditingController();
  FireStoreService fireStoreService = Get.put(FireStoreService());
  void sendComment() {
    fireStoreService.postComment(commentController.text, widget.post.postId);

    commentController.clear();
  }

  void showCommentPage() {
    showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          Tween<Offset> tween;
          tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
          return SlideTransition(
            position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
        barrierDismissible: true,
        barrierLabel: 'c',
        barrierColor: Colors.black.withOpacity(0.8),
        context: context,
        pageBuilder: (context, _, __) {
          return CommentScreen(post: widget.post);
        });
  }

  void likePost() {
    fireStoreService.likePost(widget.post.postId);
  }

  @override
  Widget build(BuildContext context) {
    PostModel post = widget.post;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Card(
        color: const Color(0xFFFCFCFC),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //USER PROFİLE PHOTO
                    SizedBox(
                      height: 65,
                      width: 300,
                      child: ListTile(
                        title: Text(
                          post.userName,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontFamily: 'Plus Jakarta Display',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text('2 hours ago'),
                        leading: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(
                              side: BorderSide(
                                  width: 1.50, color: Color(0xFFFA9884)),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(ProfilePage(
                                uid: widget.post.uid,
                              ));
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(post.profileImage),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton(
                        color: Colors.black45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        itemBuilder: (context) => [
                              PopupMenuItem(child: Text('delete')),
                              const PopupMenuItem(child: Text('about')),
                              const PopupMenuItem(child: Text('about'))
                            ])
                  ],
                ),
              ),
            ),

            // POST PHOTOS
            GestureDetector(
              onDoubleTap: likePost,
              child: SizedBox(
                height: dynamicHeight(0.5),
                width: dynamicWidth(0.9),
                child: PageView.builder(
                    controller: photoController,
                    itemCount: post.postPhotoUrl.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          post.postPhotoUrl[index]),
                                      fit: BoxFit.cover)),
                            ),

                            // PAGE INDICATOR
                            Positioned(
                              bottom: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 15),
                                child: SmoothPageIndicator(
                                    effect: const ExpandingDotsEffect(
                                      dotHeight: 10,
                                      dotWidth: 10,
                                      dotColor: Colors.white38,
                                      activeDotColor: Colors.white,
                                    ),
                                    controller: photoController,
                                    count: widget.post.postPhotoUrl.length),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
              ),
            ),

            // COMMENTS,LİKES,FORWARD,TİME

            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10, top: 5),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: likePost,
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: (isLiked) ? Colors.red : Colors.black,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      post.likes.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: showCommentPage,
                      child: Icon(Icons.chat_bubble_outline_rounded)),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 1),
                    child: Text(
                      post.comments.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.send_outlined)
                ],
              ),
            ),
            //DESCRIPTION

            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    text: post.description,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Plus Jakarta Display',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.45,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
