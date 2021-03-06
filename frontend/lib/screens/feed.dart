import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/mural_model.dart';

import 'feed_page.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Mural> murals = [];
  int counter = 0;
  int pageNo = 0;

  @override
  Widget build(BuildContext context) {
    List<Mural> murals = [];
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    muralBloc.add(FetchAllMurals(page: counter++, type: 'all'));

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
                  print('Indexxxxxxxxxxxxxxxxxxxx->>>> ${index}');
                  if (index == murals.length - 2) {
                    pageNo = murals.length - 2;
                    print('Pagggggeeeeeeeee----> ${pageNo}');
                    muralBloc.add(FetchAllMurals(page: counter++,  type: 'all'));
                    print('Pagggggeeeeeeeee2222222222----> ${pageNo}');
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
