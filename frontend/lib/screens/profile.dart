import 'dart:ui';

import 'package:frontend/bloc/mural_bloc/mural_event.dart';
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

  late String username;

  @override
  Future<void> didChangeDependencies() async {
    setState(() {
      loading = true;
    });

    if (widget.otherUsername == null) {
      username = await localRead('username');
    } else {
      username = widget.otherUsername!;
    }

    final apiRepository = ApiHandling();
    user = await apiRepository.fetchProfileMurals(username, murals, 0);
    print('username --> ${user!.username}');

    print('mural Length ${murals.length}');

    setState(() {
      loading = false;
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
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
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.red, width: 6)),
                              color: Colors.red,
                              image: DecorationImage(
                                  image: NetworkImage(user!.bioUrl),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      key: widget.key,
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
                        ),
                        Positioned(
                          top: 120,
                          left: MediaQuery.of(context).size.width / 2.7,
                          child: Container(
                            height: 95,
                            width: 95,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 3),
                              color: Colors.blue,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 6,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 9 / 16,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: murals.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           FeedPage(mural: murals[index])),
                                // );
                              },
                              child: Container(
                                width: 107,
                                height: 332,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.transparent),
                                  image: DecorationImage(
                                    image: NetworkImage(murals[index].imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
