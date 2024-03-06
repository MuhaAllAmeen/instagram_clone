import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/views/pages/add_post_page.dart';
import 'package:instagram_clone/views/pages/feed_page.dart';
import 'package:instagram_clone/views/pages/profile_page.dart';
import 'package:instagram_clone/views/pages/search_page.dart';

const webScreenSize = 600;

List<Widget> pages = [
  const FeedView(),
  const SearchView(),
  const AddPostView(),
  const Text('Likes'),
  ProfileView(uid: FirebaseAuth.instance.currentUser!.uid,)
];