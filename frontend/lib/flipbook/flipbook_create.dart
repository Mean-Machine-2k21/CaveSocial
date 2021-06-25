import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/flipbook/create_flipbook_frame.dart';
import 'package:frontend/flipbook/gif_view.dart';
// import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'functions.dart';

class CreateFlipbook extends StatefulWidget {
  CreateFlipbook({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CreateFlipbookState createState() => _CreateFlipbookState();
}

class _CreateFlipbookState extends State<CreateFlipbook> {
  var frame = 0;
  var time = 300;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E1E2A),
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
              child: Text('Add frame'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (frame == 0) {
                  final snackBar = SnackBar(
                    content: Text('First create something to view !!'),
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
              child: Text('See GIF'),
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
                    content: Text('No Frames to undo'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Undo Frame'),
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
                  content: Text('Cleared FlipBook Done !!'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Clear Flipbook'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO post gif
              },
              child: Text('Post FlipBook!!'),
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
