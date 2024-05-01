import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/views/world/add_post_view.dart';
import 'package:social_mathematicians/views/homePage/home_page.dart';
import 'package:social_mathematicians/views/profile/profile_page.dart';
import 'package:social_mathematicians/views/search/search_page.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> with TickerProviderStateMixin {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  AuthService auth = Get.put(AuthService());

  int _selectedIndex = 0;

  late AnimationController homeIconController;
  late AnimationController worldIconController;

  @override
  void initState() {
    homeIconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    worldIconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    super.initState();
  }

  List lotties = [
    'assets/lottie/home_icon_lottie.json',
    'assets/lottie/world_icon_lottie.json',
  ];

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
        pageBuilder: (_, __, ___) {
          return Container();
        });
  }

  List icons = const [
    Icon(
      Icons.add_box_outlined,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      Icons.person_2_outlined,
      color: Colors.white,
      size: 30,
    )
  ];

  void signOut() {
    auth.signOut();
  }

  final List _pages = [
    const HomePage(),
    const SearchPage(),
    const AddPost(),
    ProfilePage(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: context.height * (0.1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(255, 53, 52, 52),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        homeIconController
                            .animateTo(1)
                            .then((_) => homeIconController.animateTo(0));
                      }
                      if (index == 1) {
                        worldIconController
                            .animateTo(1)
                            .then((_) => worldIconController.animateTo(0));
                      }

                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          margin: EdgeInsets.only(
                            bottom: index == _selectedIndex ? 0 : 1,
                            right: context.width * (0.06),
                            left: context.width * (0.04),
                          ),
                          width: context.width * (0.125),
                          height: index == _selectedIndex
                              ? context.width * (0.015)
                              : 0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                          ),
                        ),
                        (index == 0 || index == 1)
                            ? SizedBox(
                                height: 40,
                                width: 40,
                                child: Lottie.asset(
                                  lotties[index],
                                  controller: (index == 0)
                                      ? homeIconController
                                      : worldIconController,
                                  repeat: true,
                                ),
                              )
                            : icons[index - 2]
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
}
