import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/feed_page.dart';

import './edit_profile.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../services/api_handling.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  String? otherUsername;
  Profile({Key? key, this.otherUsername}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Mural> murals = [];
  User? user;
  bool loading = true;
  bool isInit = true;
  bool isOther = false;

  late String username;
  var themeBloc, muralBloc;
  int cnt = 0;
  @override
  Future<void> didChangeDependencies() async {
    themeBloc = BlocProvider.of<ThemeBloc>(context);
    muralBloc = BlocProvider.of<MuralBloc>(context);
    if (isInit) {
      setState(() {
        loading = true;
      });
      print("YYYYYYYYYther Username ---> ${widget.otherUsername}");
      if (widget.otherUsername == null) {
        username = await localRead('username');
      } else {
        username = widget.otherUsername!;
        isOther = true;
      }

      print("OOOOOOOOOOther Username ---> ${username}");

      final apiRepository = ApiHandling();
      muralBloc.add(FetchProfileMurals(username: username, page: cnt++));
      user = await apiRepository.fetchProfileMurals(username, murals, 0);
      print('username --> ${user!.username}');

      print('mural Length ${murals.length}');

      isInit = false;
      setState(() {
        loading = false;
      });
    }

    super.didChangeDependencies();
  }

  List<Mural> muralsFeed = [];
  int pre = -1;
  @override
  Widget build(BuildContext context) {
    // int cnt = 0;
    //  if (cnt == 0)
    //List<Mural> murals=[];
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: themeBloc.main,
          body: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: themeBloc.contrast,
                    strokeWidth: 5,
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Container(
                        child: Stack(
                          //alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: Container(
                                width: double.infinity,
                                height: 173,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.red, width: 5)),
                                  image: DecorationImage(
                                      image: NetworkImage(user!.bioUrl),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            !isOther
                                ? Positioned(
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<ThemeBloc>.value(
                                                value: themeBloc,
                                                child: BlocProvider<
                                                    MuralBloc>.value(
                                                  value: muralBloc,
                                                  child: EditProfile(
                                                    key: widget.key,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          color: Colors.red,
                                          size: 36.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Positioned(
                              top: 120,
                              left: MediaQuery.of(context).size.width / 2.7,
                              child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  border:
                                      Border.all(color: Colors.red, width: 3),
                                  image: DecorationImage(
                                    image: NetworkImage(user!.avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '@' + user!.username,
                          style: TextStyle(
                            color:themeBloc.materialStyle.shade600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      BlocBuilder<MuralBloc, MuralState>(
                        builder: (context, state) {
                          if (state is FetchingProfileMurals)
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeBloc.contrast,
                                strokeWidth: 5,
                              ),
                            );
                          if (state is FetchedUserProfile &&
                              state.murals.length != muralsFeed.length) {
                            //pre = state.murals.length;
                            muralsFeed = state.murals;
                            pre = state.murals.length;
                            //  muralsFeed.addAll(state.murals);

                            //  FetchedUserProfile(murals: murals, user: user)

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 9 / 16,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: muralsFeed.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          'Lenggggggggg---> ${muralsFeed.length}');
                                      print(
                                          'Lenggggghhhh---> ${state.murals.length}');
                                      print("____________________" +
                                          index.toString());
                                      // if (index == muralsFeed.length - 2) {
                                      //   muralBloc.add(FetchProfileMurals(
                                      //       username: username, page: cnt++));
                                      // }

                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<ThemeBloc>.value(
                                                value: themeBloc,
                                                child: BlocProvider<
                                                    MuralBloc>.value(
                                                  value: muralBloc,
                                                  child: FeedPage(
                                                      mural: muralsFeed[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 107,
                                          height: 332,
                                          decoration: BoxDecoration(
                                            color: themeBloc.style,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: themeBloc.contrast),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  muralsFeed[index].imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            print("ppppreeee");
                            print(pre);
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 9 / 16,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: muralsFeed.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<ThemeBloc>.value(
                                                value: themeBloc,
                                                child: BlocProvider<
                                                    MuralBloc>.value(
                                                  value: muralBloc,
                                                  child: FeedPage(
                                                    mural: muralsFeed[index],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 107,
                                          height: 332,
                                          decoration: BoxDecoration(
                                            color: themeBloc.style,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: themeBloc.contrast),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  muralsFeed[index].imageUrl),
                                              fit: BoxFit.cover,
                                            ),
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
