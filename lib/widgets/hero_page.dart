import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:social_mathematicians/widgets/appbar_logo.dart';

import '../views/profile/profile_page.dart';

class HeroPage extends StatefulWidget {
  final PostModel post;
  const HeroPage({super.key, required this.post});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  PageController photoController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppbarLogo(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              widget.post.userName,
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
                  side: BorderSide(width: 1.50, color: Color(0xFFFA9884)),
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
                  backgroundImage: NetworkImage(widget.post.profileImage),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: SizedBox(
              height: context.height * (0.5),
              width: context.width * (0.9),
              child: PageView.builder(
                  controller: photoController,
                  itemCount: widget.post.postPhotoUrl.length,
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
                                        widget.post.postPhotoUrl[index]),
                                    fit: BoxFit.cover)),
                          ),

                          // PAGE INDICATOR
                          Positioned(
                            bottom: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, bottom: 15),
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
        ],
      ),
    );
  }
}
