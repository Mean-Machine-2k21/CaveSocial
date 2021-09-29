import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/services/logger.dart';

import 'feed_page.dart';

class FollowersFeed extends StatefulWidget {
  const FollowersFeed({Key? key}) : super(key: key);

  @override
  _FollowersFeedState createState() => _FollowersFeedState();
}

class _FollowersFeedState extends State<FollowersFeed> {
  List<Mural> murals = [];
  int counter = 0;
  int pageNo = 0;

  @override
  Widget build(BuildContext context) {
    List<Mural> murals = [];
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    muralBloc.add(FetchAllMurals(page: counter++, type: 'following'));

    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return BlocBuilder<MuralBloc, MuralState>(
          builder: (context, state) {
            final pageController = PageController(initialPage: pageNo);
            if (state is FetchingMurals)
              return Center(
                child: CircularProgressIndicator(
                  color: themeBloc.contrast,
                  strokeWidth: 5,
                ),
              );
            else if (state is FetchedFollowingMurals &&
                state.FollowingMurals.length != 0) {
              murals.addAll((state).FollowingMurals);
              logger.e("Following");
              murals.forEach((element) {
                logger.i(element.creatorUsername);
              });
              return PageView.builder(
                controller: pageController,
                itemCount: murals.length,
                itemBuilder: (context, index) {
                  print('Indexxxxxxxxxxxxxxxxxxxx->>>> ${index}');
                  if (index == murals.length - 2) {
                    pageNo = murals.length - 2;
                    print('Pagggggeeeeeeeee----> ${pageNo}');
                    muralBloc.add(
                        FetchAllMurals(page: counter++, type: 'following'));
                    print('Pagggggeeeeeeeee2222222222----> ${pageNo}');
                    pageController.jumpToPage(pageNo);
                  }

                  return FeedPage(mural: murals[index]);
                },
              );
            } else if (state is FetchedFollowingMurals &&
                state.FollowingMurals.length == 0 &&
                murals.isEmpty) {
              return Center(
                child: Text(
                  "Follow Someone to show thier Murals in your feed :)",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );

              // else {
              //   return PageView.builder(
              //     controller: pageController,
              //     itemCount: murals.length,
              //     itemBuilder: (context, index) {
              //       index = murals.length - 1;
              //       pageController.jumpToPage(index);
              //       return FeedPage(mural: murals[index]);
              //     },
              //   );
              // }
            } else {
              return PageView.builder(
                itemCount: murals.length,
                itemBuilder: (context, index) {
                  //  if()
                  return FeedPage(mural: murals[index]);
                },
              );
            }
          },
        );
      },
    );
  }
}
