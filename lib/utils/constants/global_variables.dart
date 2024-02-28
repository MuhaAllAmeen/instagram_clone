import 'package:flutter/material.dart';
import 'package:instagram_clone/views/pages/add_post_page.dart';
import 'package:instagram_clone/views/pages/feed_page.dart';

const webScreenSize = 600;

const pages = [
  FeedView(),
  Text('search'),
  AddPostView(),
  Text('Likes'),
  Text('Profile')
];