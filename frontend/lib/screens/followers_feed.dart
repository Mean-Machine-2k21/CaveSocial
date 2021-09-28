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
              ));
            else if (state is FetchedMurals && state.Murals.length != 0) {
              murals.addAll((state).Murals);
              ///////////////////////////////////////
              return PageView.builder(
                controller: pageController,
                itemCount: murals.length,
                itemBuilder: (context, index) {
                  logger.i('Indexxxxxxxxxxxxxxxxxxxx->>>> ${index}');
                  if (index == murals.length - 2) {
                    pageNo = murals.length - 2;
                    logger.i('Pagggggeeeeeeeee----> ${pageNo}');
                    muralBloc.add(
                        FetchAllMurals(page: counter++, type: 'following'));
                    logger.i('Pagggggeeeeeeeee2222222222----> ${pageNo}');
                    pageController.jumpToPage(pageNo);
                  }

                  //  if()
                  return FeedPage(mural: murals[index]
                      //   commentCount: 12,
                      //   creatorId: '0000',
                      //   creatorUsername: 'dummyUser',
                      //   imageUrl:
                      //       "https://res.cloudinary.com/meanmachine/image/upload/v1624571586/profileImages/mwubbpf25oohhapp8vof.jpg",
                      //   isLiked: true,
                      //   likedCount: 20,
                      //   id: '12222333333',
                      // ),
                      );
                },
              );
            } else {
              return PageView.builder(
                itemCount: murals.length,
                itemBuilder: (context, index) {
                  //  if()
                  return FeedPage(mural: murals[index]
                      //   commentCount: 12,
                      //   creatorId: '0000',
                      //   creatorUsername: 'dummyUser',
                      //   imageUrl:
                      //       "https://res.cloudinary.com/meanmachine/image/upload/v1624571586/profileImages/mwubbpf25oohhapp8vof.jpg",
                      //   isLiked: true,
                      //   likedCount: 20,
                      //   id: '12222333333',
                      // ),
                      );
                },
              );
            }
          },
        );
      },
    );
  }
}
