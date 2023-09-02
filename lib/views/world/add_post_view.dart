import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_mathematicians/helpers/consts.dart';
import 'package:social_mathematicians/services/firestore_service.dart';
import 'package:social_mathematicians/widgets/appbar_logo.dart';
import 'package:social_mathematicians/widgets/my_button.dart';
import 'package:social_mathematicians/widgets/my_textfield.dart';
import '../../services/storage_service.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends Const<AddPost> {
  int itemcount = 0;

  StorageService storageService = Get.put(StorageService());
  FireStoreService fireStoreService = Get.put(FireStoreService());

  void uploadPost() {
    fireStoreService.uploadPost(
      descriptionController.text,
      isPublic ? 'public' : 'private',
      photoUrlList,
    );
  }

  bool isPublic = false;
  void publicOrPrivate() {
    setState(() {
      isPublic = !isPublic;
    });
  }

  List photoUrlList = [];
  imagePicker() async {
    try {
      File image = await storageService.imageFromGallery();
      String photoUrl = await storageService.uploadImage(image);
      photoUrlList.add(photoUrl);
      setState(() {});
    } catch (e) {
      Get.snackbar('Something went wrong!', 'Please try again');
    }
  }

  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: photoUrlList.isEmpty
          ? Container()
          : Align(
              alignment: const Alignment(1, -0.6),
              child: FloatingActionButton(
                elevation: 10,
                onPressed: imagePicker,
                child: const Icon(Icons.add_a_photo),
              ),
            ),
      appBar: AppBar(elevation: 14, title: const AppbarLogo()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            photoUrlList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: InkWell(
                      onTap: imagePicker,
                      child: Container(
                        height: dynamicHeight(0.3),
                        width: dynamicWidth(0.5),
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 1.50, color: Colors.black),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: SizedBox(
                      height: dynamicHeight(0.3),
                      width: dynamicWidth(1),
                      child: CarouselSlider.builder(
                        itemCount: photoUrlList.length,
                        options: CarouselOptions(
                          aspectRatio: 0.1,
                          enableInfiniteScroll: false,
                        ),
                        itemBuilder: (context, index, __) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                      width: 1.50, color: Colors.black),
                                ),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      photoUrlList[index],
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

            //public or private type buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: publicOrPrivate,
                    child: Card(
                      color: (isPublic) ? Colors.grey : Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Text(
                          'Private',
                          style: themeData.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: publicOrPrivate,
                    child: Card(
                      color: (isPublic) ? Colors.black : Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Text(
                          'Public',
                          style: themeData.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Post description textfield
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MyTextfield(
                controller: descriptionController,
                hintText: 'Write something...',
                isObscured: false,
                icon: const Icon(
                  Icons.comment_bank,
                  color: Colors.black,
                ),
              ),
            ),
            //Share Button
            MyButton(
              buttonText: 'Share',
              onTap: uploadPost,
            )
          ],
        ),
      ),
    );
  }
}
