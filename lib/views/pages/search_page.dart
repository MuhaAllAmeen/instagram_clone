import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/views/pages/profile_page.dart';
import 'package:collection/collection.dart';

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
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      final snapData = (snapshot.data! as dynamic).docs[index];
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileView(uid: snapData['uid']),
                        )),
                        child: ListTile(
                          leading:
                              snapData.data().toString().contains('photoUrl')
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(snapData['photoUrl']),
                                      radius: 16,
                                    )
                                  : null,
                          title: Text(snapData['username']),
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
                      crossAxisCount: 4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      axisDirection: AxisDirection.right,
                      children: (snapshot.data!
                              as QuerySnapshot<Map<String, dynamic>>)
                          .docs
                          .mapIndexed((i, e) => StaggeredGridTile.count(
                                mainAxisCellCount: i % 2 == 0 ? 3 : 1,
                                crossAxisCellCount: i % 2 == 0 ? 1 : 3,
                                child: Image.network(
                                  e['postUrl'],
                                  fit: BoxFit.cover,
                                ),
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
