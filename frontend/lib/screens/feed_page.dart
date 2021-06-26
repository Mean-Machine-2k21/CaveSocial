import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/global.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/feed_comment.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/api_handling.dart';
import 'package:swipe_up/swipe_up.dart';
import '../models/mural_model.dart';

//Liked by page and api calling hre..............#################################################
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.mural}) : super(key: key);
  final Mural mural;
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  MuralRepository muralRepository = MuralRepository();
  @override
  Widget build(BuildContext context) {
    double cwidth = MediaQuery.of(context).size.width;
    double cheight = MediaQuery.of(context).size.height;
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    return BlocBuilder<MuralBloc, MuralState>(
      builder: (context, state) {
        // if(state is NoReqState)
        //{
        return Scaffold(
          body: GestureDetector(
            onVerticalDragUpdate: (details) {
              print('heloooo');
              if (details.delta.dy < 0) {
                print('Swiped Up');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: themeBloc,
                      child: BlocProvider.value(
                        value: muralBloc,
                        child: FeedComment(
                          parentMuralid: widget.mural.id,
                        ),
                      ),
                      //FeedComment(parentMuralid: widget.mural.id,),
                    ),
                  ),
                );
              }
            },
            child: InkWell(
              onDoubleTap: () {
                if (!widget.mural.isLiked) {
                  setState(() {
                    widget.mural.isLiked = true;
                    widget.mural.likedCount++;
                  });

                  // muralBloc.add(LikeMural(muralid: widget.mural.id));
                  muralRepository.likeMural(muralId: widget.mural.id);
                } // setState(() {

                // });
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
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '@${widget.mural.creatorUsername}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                // onLongPress: (){

                                // },
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    if (!widget.mural.isLiked) {
                                      setState(() {
                                        widget.mural.isLiked =
                                            !widget.mural.isLiked;
                                        widget.mural.likedCount++;
                                      });

                                      // muralBloc.add(
                                      //     LikeMural(muralid: widget.mural.id));
                                      muralRepository.likeMural(
                                          muralId: widget.mural.id);
                                    } else {
                                      setState(() {
                                        widget.mural.isLiked =
                                            !widget.mural.isLiked;
                                        widget.mural.likedCount--;
                                      });

                                      // muralBloc.add(UnLikeMural(
                                      //     muralid: widget.mural.id));
                                      muralRepository.unLikeMural(
                                          muralId: widget.mural.id);
                                    }
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
                              ),
                              Text(
                                '${widget.mural.likedCount}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: themeBloc,
                                        child: BlocProvider.value(
                                          value: muralBloc,
                                          child: FeedComment(
                                            parentMuralid: widget.mural.id,
                                          ),
                                        ),
                                        //FeedComment(parentMuralid: widget.mural.id,),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  FontAwesome.comment_o,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${widget.mural.commentCount}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: themeBloc,
                                        child: Profile(),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Ionicons.md_person,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 20),
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

        // }
      },
    );
  }
}
