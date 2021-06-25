import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cwidth = MediaQuery.of(context).size.width;
    double cheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: cheight,
              width: cwidth,
              color: Colors.blue,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      MaterialIcons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesome.comment_o,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Ionicons.md_person,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
