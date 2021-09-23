import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import '../flipbook/flipbook_create.dart';

String imageUrl = "", flipUrl = "";
int frame = 0, time = 0;
void funct(image) {
  imageUrl = image;
}

void flipfunct(gif, frames, times) {
  flipUrl = gif;
  frame = frames;
  time = times;
}

MuralRepository muralRepository = MuralRepository();

void onCreate(BuildContext context) {
  var themeBloc = BlocProvider.of<ThemeBloc>(context);
  var muralBloc = BlocProvider.of<MuralBloc>(context);

  // BlocListener<ThemeBloc, ThemeData>(listener: (context, state) {
  // TODO: implement listener

  showModalBottomSheet(
    context: context,

    barrierColor: Colors.black.withOpacity(0.2),

    backgroundColor: themeBloc.main,

    elevation: 100,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      //  BorderRadius.circular(30.0),
    ),
    // isDismissible: true,
    builder: (BuildContext context) {
      return Container(
        height: 150,

        // decoration:
        //     BoxDecoration(borderRadius: BorderRadius.circular(200)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Choose Mode',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), primary: Color(0xffFF3E3E)),
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Text(
                        'Normal',
                        style:
                            TextStyle(fontSize: 14, color: themeBloc.contrast),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateMuralScreen(
                            'normal',
                            editProfile: funct,
                          ),
                        ),
                      );

                      muralRepository.createMural(content: imageUrl);
                      Navigator.pop(context);

                      ///
                      ///
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), primary: Color(0xffFF3E3E)),
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Text(
                        'Comic',
                        style:
                            TextStyle(fontSize: 14, color: themeBloc.contrast),
                      ),
                    ),
                    onPressed: () async {
                      // await Navigator.push(
                      //   context,
                      //   //CreateMuralScreen('comic');
                      //   MaterialPageRoute(
                      //     builder: (context) => BlocProvider.value(
                      //       value: themeBloc,
                      //       child: BlocProvider.value(
                      //         value: muralBloc,
                      //         child: CreateMuralScreen(
                      //           'comic',
                      //           editProfile: funct,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // );
                      // muralRepository.createMural(content: imageUrl);
                      // Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateMuralScreen(
                            'comic',
                            editProfile: funct,
                          ),
                        ),
                      );

                      muralRepository.createMural(content: imageUrl);
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), primary: Color(0xffFF3E3E)),
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Text(
                        'Flipbook',
                        style:
                            TextStyle(fontSize: 14, color: themeBloc.contrast),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                                  value: themeBloc,
                                  child: BlocProvider.value(
                                    value: muralBloc,
                                    child: CreateFlipbook(
                                      title: 'Flipbook',
                                      editProfile: flipfunct,
                                    ),
                                  ),
                                )),
                      );

                      muralRepository.createMural(
                        content: flipUrl,
                        flipbook: Flipbook(
                          duration: time,
                          frames: frame,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  //});
}
