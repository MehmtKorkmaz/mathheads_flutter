import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_mathematicians/model/post_model.dart';
import 'package:social_mathematicians/widgets/appbar_logo.dart';
import 'package:social_mathematicians/widgets/post_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppbarLogo(),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/lottie/loading_lottie.json'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                PostModel post = PostModel.fromSnap(snapshot.data!.docs[index]);
                if (post.type == 'public') {
                  return PostCard(post: post);
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }
}
