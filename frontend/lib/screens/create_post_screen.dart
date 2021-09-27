import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import '../flipbook/flipbook_create.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override

  Widget build(BuildContext context) {
  var themeBloc = BlocProvider.of<ThemeBloc>(context);
    //var themeBloc = BlocProvider.of<MuralBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xff1E1E2A),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // adding some properties
            showModalBottomSheet(
              context: context,

              barrierColor: Colors.black.withOpacity(0.2),

              backgroundColor: themeBloc.main,

              elevation: 100,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
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
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Normal',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateMuralScreen('normal')),
                                );
                                Navigator.pop(context);

                                ///
                                ///
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Comic',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateMuralScreen('comic')),
                                );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Flipbook',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateFlipbook(
                                            title: 'Flipbook',
                                          )),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Create Mural'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
