import 'package:flutter/material.dart';

import 'feed_page.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0);
    return PageView.builder(
      itemBuilder: (context, index) {
        return FeedPage();
      },
    );
  }
}
