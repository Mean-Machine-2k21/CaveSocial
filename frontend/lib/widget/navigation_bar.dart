import 'package:flutter/material.dart';
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
    List<Map<String, dynamic>> _items = [
      {
        'name': 'Feed',
        'child': Icon(
          Icons.home,
          color: _selectedIndex == 0 ? color.style : color.contrast,
        ),
      },
      {
        'name': 'Create',
        'child': Icon(
          Icons.add,
          color: _selectedIndex == 1 ? color.style : color.contrast,
        ),
      },
      {
        'name': 'Message',
        'child': Icon(
          Icons.person,
          color: _selectedIndex == 2 ? color.style : color.contrast,
        ),
      },
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: color.black
              .withOpacity(color.chooser(lightMode: 0.2, darkMode: 0.4)),
          blurRadius: MediaQuery.of(context).size.height / 4,
        ),
      ], color: color.main),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              textColor: (_selectedIndex == i) ? color.style : color.contrast,
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

  NavigationBarItem({
    this.label,
    required this.child,
    required this.onSelect,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / (5),
      padding: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: color.main,
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
