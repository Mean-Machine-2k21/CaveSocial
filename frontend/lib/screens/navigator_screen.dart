import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/screens/feed.dart';
import 'package:frontend/screens/feed_page.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/logger.dart';
import 'package:frontend/services/movie_search_service.dart';
import 'package:frontend/services/search_api.dart';
import 'package:frontend/widget/create_post_modal.dart';
import 'package:frontend/widget/navigation_bar.dart';

import '../global.dart';
import 'followers_feed.dart';
import 'movie_search_delegate.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage();

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);

    _widgetOptions = <Widget>[
      BlocProvider.value(
        value: themeBloc,
        child: BlocProvider.value(
          value: muralBloc,
          child: FollowersFeed(),
        ),
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      BlocProvider.value(
        value: themeBloc,
        child: BlocProvider.value(
          value: muralBloc,
          child: Feed(),
        ),
      ),
      BlocProvider.value(
        value: themeBloc,
        child: BlocProvider.value(
          value: muralBloc,
          child: Profile(),
        ),
      ),
    ];

    // TODO: implement initState
    super.initState();
  }

  Future<SearchResult?> _showSearch(BuildContext context) async {
    final searchService = MovieSearchService(apiWrapper: SearchApi());
    final user = await showSearch<SearchResult>(
      context: context,
      delegate: MovieSearchDelegate(searchService),
    );

    searchService.dispose();
    return user;
    // print('user');
    // print(user!.userId);
    // print('user');
  }

  @override
  Widget build(BuildContext context) {
    // theme
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BlocProvider<ThemeBloc>.value(
        value: BlocProvider.of<ThemeBloc>(context),
        child: AppNavigationBar(
          onChange: (val) async {
            if (val == 2) {
              onCreate(context);
            } else if (val == 1) {
              SearchResult? user = await _showSearch(context);

              if (user == null) {
              } else {
                // logger.i(user!.username + "     aajsfha");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<ThemeBloc>.value(
                      value: themeBloc,
                      child: BlocProvider<MuralBloc>.value(
                        value: muralBloc,
                        child: Profile(
                          otherUsername: user.username,
                          otherId: user.userId,
                        ),
                      ),
                    ),
                  ),
                );
              }
            } else {
              setState(() {
                _selectedIndex = val;
              });
            }
          },
          defaultIndex: 0,
        ),
      ),
    );
  }
}
