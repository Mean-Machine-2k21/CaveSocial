import 'dart:io';

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
import 'package:frontend/screens/liked_by_screen.dart';

import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/api_handling.dart';
import 'package:frontend/services/logger.dart';
import 'package:frontend/widget/shimmer_image.dart';
import 'package:frontend/widget/showflip_book.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipe_up/swipe_up.dart';
import '../models/mural_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

//Liked by page and api calling hre..............#################################################
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.mural}) : super(key: key);
  final Mural mural;
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  MuralRepository muralRepository = MuralRepository();

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  shareWatsapp(String username, String imageUrl, String id, int number) async {
    var myFile = await file("myFileName.png");
    final response = await http.get(Uri.parse(imageUrl));
    myFile.writeAsBytesSync(response.bodyBytes);

    //NetworkToFileImage(url: "https://example.com/someFile.png", file: myFile);

    final box = context.findRenderObject() as RenderBox?;
    // String? result = await FlutterSocialContentShare.shareOnWhatsapp(
    //     "0000000", "Text Appear hear");

    logger.i(imageUrl);
    logger.i(myFile.path);
    Share.shareFiles([myFile.path],
        text:
            'Follow @${username} and come hangout with me on CaveSocial. #letsGetPrimitiveTogether');
    //Share.share('CaveSocial');
    // Share.share('check out my website https://example.com',
    //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    // await FlutterSocialContentShare.share(
    //     type: ShareType.instagramWithImageUrl,
    //     imageName: username,
    //     imageUrl: imageUrl,
    //     quote: "Download CaveSocial",
    //     url: "https://github.com/Mean-Machine-2k21/CaveSocial");
    //logger.i(result);
  }

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
                        // decoration: BoxDecoration(
                        //   color: Colors.blue,
                        //   image: widget.mural.flipbook == null
                        //       ? DecorationImage(
                        //           image: NetworkImage(
                        //             widget.mural.imageUrl,
                        //           ),
                        //           fit: BoxFit.cover,
                        //         )
                        //       : null,
                        // ),
                        child: widget.mural.flipbook != null
                            ? ShowFlipBook(
                                widget.mural.imageUrl,
                                frames: widget.mural.flipbook!.frames,
                                time: widget.mural.flipbook!.duration,
                              )
                            : ShimmerNetworkImage(
                                widget.mural.imageUrl,
                                boxFit: BoxFit.cover,
                              )
                        // : FancyShimmerImage(
                        //     imageUrl: widget.mural.imageUrl,
                        //   ),
                        //: null,
                        ),
                    Container(
                      height: cheight,
                      width: cwidth,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<ThemeBloc>.value(
                                      value: themeBloc,
                                      child: BlocProvider<MuralBloc>.value(
                                        value: muralBloc,
                                        child: Profile(
                                          otherUsername:
                                              widget.mural.creatorUsername,
                                          otherId: widget.mural.creatorId,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  shareWatsapp(
                                      widget.mural.creatorUsername,
                                      widget.mural.imageUrl,
                                      widget.mural.id,
                                      widget.mural.likedCount);
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.red,
                                ),
                              ),
                              InkWell(
                                // onLongPress: (){

                                // },
                                child: InkWell(
                                  onLongPress: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: themeBloc,
                                        child: BlocProvider.value(
                                          value: muralBloc,
                                          child: LikedByScreen(
                                            muralid: widget.mural.id,
                                          ),
                                        ),
                                        //FeedComment(parentMuralid: widget.mural.id,),
                                      ),
                                    ));
                                  },
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
