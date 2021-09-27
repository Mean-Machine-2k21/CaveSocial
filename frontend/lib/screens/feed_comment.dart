import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:frontend/screens/edit_profile.dart';
import 'package:frontend/screens/feed_page.dart';
import 'package:frontend/widget/shimmer_image.dart';

class FeedComment extends StatefulWidget {
  const FeedComment({Key? key, required this.parentMuralid}) : super(key: key);
  final String parentMuralid;
  @override
  _FeedCommentState createState() => _FeedCommentState();
}

class _FeedCommentState extends State<FeedComment> {
  @override
  //String parentMuralid = '';
  String comment = ' ';
  int counter = 0;
  void fun(String s) {
    comment = s;
  }

  String usernameUrl(username) {
    return 'https://firebasestorage.googleapis.com/v0/b/cavesocial-78776.appspot.com/o/uploads%2fprofileImages%2f' +
        username +
        '?alt=media&token=c2033fb1-2be9-4616-adfd-2996c5c13749';
  }

  Widget build(BuildContext context) {
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    List<Mural> muralComments = [];

    muralBloc.add(
      FetchMuralCommentList(muralid: widget.parentMuralid, page: counter++),
    );
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: themeBloc.main,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateMuralScreen('normal', editProfile: fun),
                ),
              );

              muralBloc.add(
                CommentMural(
                    parentMuralId: widget.parentMuralid, content: comment),
              );
            },
            child: Icon(Icons.add),
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    left: 8.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Ionicons.md_arrow_round_back,
                        ),
                      ),
                      Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeBloc.contrast,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<MuralBloc, MuralState>(
                  builder: (context, state) {
                    if (state is MuralCommentLoading)
                      return Center(
                        child: CircularProgressIndicator(
                          color: themeBloc.contrast,
                          strokeWidth: 5,
                        ),
                      );
                    else if (state is FetchedMuralCommentList &&
                        state.muralCommentList.length != 0) {
                    //  muralComments.addAll(state.muralCommentList);
                      muralComments = state.muralCommentList;
                      print('mural Commentssssss---> ${muralComments.length}');
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 9 / 12,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: muralComments.length,
                              itemBuilder: (context, index) {
                                if (index == muralComments.length - 2)
                                  muralBloc.add(
                                    FetchMuralCommentList(
                                      muralid: widget.parentMuralid,
                                      page: counter++,
                                    ),
                                  );
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<ThemeBloc>.value(
                                          value: themeBloc,
                                          child: BlocProvider<MuralBloc>.value(
                                            value: muralBloc,
                                            child: FeedPage(
                                              mural: muralComments[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  usernameUrl(
                                                      muralComments[index]
                                                          .creatorUsername)),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              muralComments[index]
                                                  .creatorUsername,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: themeBloc.style),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12.0,
                                                right: 16.0,
                                              ),
                                              child: Container(
                                                width: 307,
                                                height: 432,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // image: DecorationImage(
                                                  //   image: NetworkImage(
                                                  // muralComments[index]
                                                  //     .imageUrl,
                                                  //   ),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color:
                                                          themeBloc.contrast),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: ShimmerNetworkImage(
                                                    muralComments[index]
                                                        .imageUrl,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 60,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      MaterialIcons.favorite,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(muralComments[index]
                                                      .likedCount
                                                      .toString()),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 9 / 12,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: muralComments.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<ThemeBloc>.value(
                                          value: themeBloc,
                                          child: BlocProvider<MuralBloc>.value(
                                            value: muralBloc,
                                            child: FeedPage(
                                              mural: muralComments[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  usernameUrl(
                                                      muralComments[index]
                                                          .creatorUsername)),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              muralComments[index]
                                                  .creatorUsername,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12.0,
                                                right: 16.0,
                                              ),
                                              child: Container(
                                                width: 307,
                                                height: 432,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // image: DecorationImage(
                                                  //   image: NetworkImage(
                                                  // muralComments[index]
                                                  //     .imageUrl,
                                                  //   ),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: ShimmerNetworkImage(
                                                    muralComments[index]
                                                        .imageUrl,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 60,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      MaterialIcons.favorite,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(muralComments[index]
                                                      .likedCount
                                                      .toString()),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
