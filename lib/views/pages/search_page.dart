import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/views/pages/profile_page.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
          title: TextFormField(
        controller: searchController,
        decoration: const InputDecoration(labelText: 'Search for a user'),
        onFieldSubmitted: (value) {
          setState(() {
            isShowUser = true;
          });
        },
      )),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.toString());
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileView(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid']),
                        )),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage((snapshot.data!
                                    as QuerySnapshot<Map<String, dynamic>>)
                                .docs[index]['photoUrl']),
                            radius: 16,
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StaggeredGrid.count(
                      crossAxisCount: 3,
                      children: (snapshot.data!
                              as QuerySnapshot<Map<String, dynamic>>)
                          .docs
                          .map((e) => StaggeredGridTile.count(
                                mainAxisCellCount: 1,
                                crossAxisCellCount: 1,
                                child: Image.network(e['postUrl']),
                              ))
                          .toList());
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
