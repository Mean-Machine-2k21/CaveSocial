import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/liked_user.dart';
import 'package:frontend/screens/profile.dart';

class LikedByScreen extends StatelessWidget {
  final String muralid;

  LikedByScreen({
    required this.muralid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Liked By ';
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    muralBloc.add(FetchMuralLikeList(muralid: muralid, page: 0));
    String UsernameUrl(username) {
      return 'https://firebasestorage.googleapis.com/v0/b/cavesocial-78776.appspot.com/o/uploads%2fprofileImages%2f' +
          username +
          '?alt=media&token=c2033fb1-2be9-4616-adfd-2996c5c13749';
    }

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
            if (state is FetchedMuralLikeList) print('pkkkkkkkkkk@@@@@@@@@@@');
            if (state is FetchedMuralLikeList && state.usernames.length != 0)
            //
            {
              List<LikedUsers> likedUsers = [];
              likedUsers = (state).usernames;
              print('##################################################');
              print(likedUsers.length);
              return ListView.builder(
                itemCount: likedUsers.length,
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
                              backgroundImage: NetworkImage(
                                  UsernameUrl(likedUsers[index].username)),
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Text(
                                '@' + likedUsers[index].username,
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
                                              likedUsers[index].username,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FetchedMuralLikeList) {
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
