import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/feed_comment.dart';
import 'package:swipe_up/swipe_up.dart';
import '../models/mural_model.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.mural}) : super(key: key);
  final Mural mural;
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    double cwidth = MediaQuery.of(context).size.width;
    double cheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          print('heloooo');
          print('Swiped Up');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FeedComment(),
            ),
          );
        },
        child: InkWell(
          onDoubleTap: () {
            setState(() {
              widget.mural.isLiked = true;
            });
          },
          child: Container(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: cheight,
                  width: cwidth,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.mural.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: cheight,
                  width: cwidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '@${widget.mural.creatorUsername}',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.mural.isLiked = !widget.mural.isLiked;
                              });
                            },
                            icon: widget.mural.isLiked
                                ? Icon(
                                    MaterialIcons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    MaterialIcons.favorite_border,
                                    color: Colors.red,
                                  ),
                          ),
                          Text('${widget.mural.likedCount}'),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesome.comment_o,
                            ),
                          ),
                          Text('${widget.mural.commentCount}'),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FeedComment(),
                                ),
                              );
                            },
                            icon: Icon(
                              Ionicons.md_person,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
