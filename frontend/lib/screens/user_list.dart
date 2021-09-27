import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/liked_user.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_list.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/feed_page.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/widget/create_post_modal.dart';
import 'package:frontend/widget/shimmer_image.dart';

import './edit_profile.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../services/api_handling.dart';
import '../services/logger.dart';

class UserListScreen extends StatelessWidget {
  final String userId;
  final String type;

  UserListScreen({
    required this.userId,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = type;
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    //muralBloc.add(FetchMuralLikeList(muralid: muralid, page: 0));
    muralBloc.add(FetchUserList(userid: userId, type: type));
    // String UsernameUrl(username) {
    //   return 'https://firebasestorage.googleapis.com/v0/b/cavesocial-78776.appspot.com/o/uploads%2fprofileImages%2f' +
    //       username +
    //       '?alt=media&token=c2033fb1-2be9-4616-adfd-2996c5c13749';
    // }

    return MaterialApp(
      title: title,
      home: Scaffold(
        backgroundColor: themeBloc.main,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            title,
            style: TextStyle(color: themeBloc.contrast),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<MuralBloc, MuralState>(
          builder: (context, state) {
            // if (state is FetchedMuralLikeList) print('pkkkkkkkkkk@@@@@@@@@@@');
            if (state is FetchedUserList && state.users.length != 0)
            //
            {
              List<UserList> userList = [];
              userList = (state).users;
              //print('##################################################');
              //print(userList.length);
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: themeBloc.contrast),
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      title: Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userList[index].avatarUrl),
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Text(
                                '@' + userList[index].username,
                                maxLines: 1,
                                style: TextStyle(color: themeBloc.style),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<ThemeBloc>.value(
                                      value: themeBloc,
                                      child: BlocProvider<MuralBloc>.value(
                                        value: muralBloc,
                                        child: Profile(
                                          otherUsername:
                                              userList[index].username,
                                          otherId: userList[index].userId,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Spacer(),
                            userList[index].isFollowed
                                ? Text(
                                    '. Following',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                : Text(
                                    '. Follow',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FetchingUserList) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 5.0,
                ),
              );
            } else
              // if (state is FetchingMuralLikeList)
              return Center(
                child: CircularProgressIndicator(
                  color: themeBloc.contrast,
                  strokeWidth: 5.0,
                ),
              );
          },
        ),
      ),
    );
  }
}
