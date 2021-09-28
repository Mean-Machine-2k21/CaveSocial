import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import '../global.dart';

class AppNavigationBar extends StatefulWidget {
  final int defaultIndex;
  final Function(int) onChange;

  AppNavigationBar({this.defaultIndex = 0, required this.onChange});
  @override
  _AppNavigationBarState createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    List<Map<String, dynamic>> _items = [
      {
        'name': 'Feed',
        'child': Icon(
          Icons.home,
          color: _selectedIndex == 0 ? themeBloc.style : themeBloc.contrast,
        ),
      },
      {
        'name': 'Search',
        'child': Icon(
          Entypo.magnifying_glass,
          color: _selectedIndex == 1 ? themeBloc.style : themeBloc.contrast,
        ),
      },
      {
        'name': 'Create',
        'child': Icon(
          Ionicons.md_create,
          color: _selectedIndex == 2 ? themeBloc.style : themeBloc.contrast,
        ),
      },
      {
        'name': 'Explore',
        'child': Icon(
          MaterialIcons.explore,
          color: _selectedIndex == 3 ? themeBloc.style : themeBloc.contrast,
        ),
      },
      {
        'name': 'Profile',
        'child': Icon(
          Icons.person,
          color: _selectedIndex == 4 ? themeBloc.style : themeBloc.contrast,
        ),
      },
    ];
    var itemWidth = MediaQuery.of(context).size.width / 5;
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: themeBloc.contrast
              .withOpacity(color.chooser(lightMode: 0.2, darkMode: 0.4)),
          blurRadius: MediaQuery.of(context).size.height / 5,
        ),
      ], color: themeBloc.main),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
                color: Colors.transparent,
                width: _selectedIndex == 0
                    ? MediaQuery.of(context).size.width * 0.0
                    : itemWidth * _selectedIndex,
                height: 4.0,
              ),
              Flexible(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                  width: itemWidth,
                  height: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(4)),
                      child: Container(
                        height: 4,
                        color: color.style,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4)),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < _items.length; i++)
                NavigationBarItem(
                  label: _items[i]['name'] as String,
                  child: _items[i]['child'] as Widget,
                  onSelect: () {
                    widget.onChange(i);
                    setState(() {
                      _selectedIndex = i;
                    });
                  },
                  textColor: (_selectedIndex == i)
                      ? themeBloc.style
                      : themeBloc.contrast,
                  back: themeBloc.main,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  final String? label;
  final VoidCallback onSelect;
  final Widget child;
  final Color? textColor;
  final Color? back;

  NavigationBarItem({
    this.label,
    required this.child,
    required this.onSelect,
    this.textColor,
    this.back,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: back,
      width: MediaQuery.of(context).size.width / (5),
      padding: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: back,
          child: InkWell(
            onTap: onSelect,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: FittedBox(
                      child: child,
                    ),
                  ),
                  if (label != null)
                    SizedBox(
                      height: 4,
                    ),
                  if (label != null)
                    Text(
                      label ?? '',
                      style: style.body.copyWith(
                        fontSize: 9,
                        color: textColor,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
