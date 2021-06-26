import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/screens/feed.dart';
import 'package:frontend/screens/feed_page.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/widget/create_post_modal.dart';
import 'package:frontend/widget/navigation_bar.dart';

import '../global.dart';

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
          child: Feed(),
        ),
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height:50,
        child: AppNavigationBar(
          onChange: (val) {
            if (val == 1) {
              onCreate(context);
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
