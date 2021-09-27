import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/flipbook/create_flipbook_frame.dart';
import 'package:frontend/flipbook/gif_view.dart';
import 'package:frontend/services/add_gif_fuction.dart';
// import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'functions.dart';

class CreateFlipbook extends StatefulWidget {
//  CreateFlipbook({Key? key, required this.title}) : super(key: key);
  final String title;
  Function? editProfile;
  //var frame;
  //var time;
  CreateFlipbook(
      //  this.frame,
      //this.time,
      {
    this.editProfile,
    required this.title,
  });
  @override
  _CreateFlipbookState createState() => _CreateFlipbookState();
}

class _CreateFlipbookState extends State<CreateFlipbook> {
  @override
  void initState() {
    // TODO: implement initState
    clear();
    super.initState();
  }

  var frame = 0;
  var time = 300;
  @override
  Widget build(BuildContext context) {
      var themeBloc = BlocProvider.of<ThemeBloc>(context);
  //  var muralBloc = BlocProvider.of<MuralBloc>(context);

    return Scaffold(
      backgroundColor: themeBloc.main,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var check = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFrame('normal'),
                  ),
                );

                if (check) {
                  setState(() {
                    frame++;
                  });
                }
              },
              child: Text('Add frame',style: TextStyle(color:themeBloc.contrast)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (frame == 0) {
                  final snackBar = SnackBar(
                    content: Text('First create something to view !!',style: TextStyle(color:themeBloc.contrast)),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GifView(frame, time)),
                  );
                }
              },
              child: Text('See GIF',style: TextStyle(color:themeBloc.contrast)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (frame != 0) {
                  await undo();
                  setState(() {
                    frame--;
                  });
                  final snackBar = SnackBar(
                    content: Text('Undo Done !!'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                    content: Text('No Frames to undo',style: TextStyle(color:themeBloc.contrast)),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Undo Frame',style: TextStyle(color:themeBloc.contrast)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                clear();
                setState(() {
                  frame = 0;
                });

                final snackBar = SnackBar(
                  content: Text('Cleared FlipBook Done !!',style: TextStyle(color:themeBloc.contrast)),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Clear Flipbook',style: TextStyle(color:themeBloc.contrast)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO post gif

                var aa = await getgif();
                var aate = DateTime.now().toString();
                final Directory systemTempDir = Directory.systemTemp;
                final File file =
                    await new File('${systemTempDir.path}/foo${aate}.gif')
                        .create();
                file.writeAsBytes(aa);

                final snackBar = SnackBar(
                  content: Text('Yay! Your Mural is posted!'),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                );

                // print(file);
                //  await uploadGifToFirebase(file);

                //  final snackBar = SnackBar(
                //           content: Text('Yay! Your Mural is posted!'),
                //           duration: Duration(seconds: 5),
                //           backgroundColor: Colors.red,
                //         );

                print(file);
                await uploadGifToFirebase(file).then((value) {
                  print('Murall');
                  print(value);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  widget.editProfile!(value, frame, time);
                  Navigator.pop(context);
                });
              },
              child: Text('Post FlipBook!!',style: TextStyle(color:themeBloc.contrast)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          'Fast',
                          style: TextStyle(color: Colors.red),
                        ),
                        Spacer(),
                        Text(
                          'Slow',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  Slider(
                    value: time.toDouble(),
                    onChanged: (double value) => setState(() {
                      time = value.toInt();
                    }),
                    min: 50,
                    max: 2000,
                    activeColor: Colors.red,
                    inactiveColor: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
