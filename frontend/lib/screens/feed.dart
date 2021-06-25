import 'package:flutter/material.dart';
import 'package:frontend/models/mural_model.dart';

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
        return FeedPage(
          mural: Mural(
            commentCount: 12,
            creatorId: '0000',
            creatorUserName: 'dummyUser',
            imageUrl:
                "https://res.cloudinary.com/meanmachine/image/upload/v1624571586/profileImages/mwubbpf25oohhapp8vof.jpg",
            isLiked: true,
            likedCount: 20,
          ),
        );
      },
    );
  }
}
