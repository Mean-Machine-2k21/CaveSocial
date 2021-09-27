import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frontend/services/add_image_fuction.dart';
import './painter.dart';

class ExamplePage extends StatefulWidget {
  final String mode;
  ExamplePage(this.mode);

  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _finished = false;
  late String mode;
  late PainterController _controller = _newController(mode);

  @override
  void initState() {
    mode = widget.mode;
    super.initState();
  }

  static PainterController _newController(String s) {
    PainterController controller = new PainterController(s);
    controller.thickness = 5.0;
    controller.backgroundColor = Color(0xff1E1E2A);
    controller.drawColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        new IconButton(
          icon: new Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController('s');
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.red,
              size: 32,
            ),
            tooltip: 'back',
            onPressed: () {
              Navigator.of(context).pop();
            }),
        Spacer(),
        // new IconButton(
        //     icon: new Icon(Icons.delete),
        //     tooltip: 'Clear',
        //     onPressed: _controller.clear),

        new IconButton(
            icon: new Icon(
              Icons.check,
              color: Colors.red,
              size: 32,
            ),
            onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return new Scaffold(
      // appBar: new AppBar(
      //   title: const Text('Painter Example'),

      //   actions: actions,
      // ),
      body: new Center(
        child: Stack(
          children: [
            Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: new Painter(_controller)),
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  Icon(
                    FontAwesome.paint_brush,
                    color: Colors.red,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: 70,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: new StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return new Container(
                            child: new Slider(
                          value: _controller.thickness,
                          onChanged: (double value) => setState(() {
                            _controller.thickness = value;
                          }),
                          min: 1.0,
                          max: 40.0,
                          activeColor: Colors.red,
                          inactiveColor: Colors.redAccent,
                        ));
                      }),
                    ),
                  ),
                  new ColorPickerButton(_controller, false),
                  SizedBox(
                    height: 20,
                  ),
                  new ColorPickerButton(_controller, true),
                  SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return new RotatedBox(
                        quarterTurns: _controller.eraseMode ? 2 : 0,
                        child: IconButton(
                            icon: new Icon(
                              Icons.create,
                              color: Colors.red,
                              size: 28,
                            ),
                            tooltip:
                                (_controller.eraseMode ? 'Disable' : 'Enable') +
                                    ' eraser',
                            onPressed: () {
                              setState(() {
                                _controller.eraseMode = !_controller.eraseMode;
                              });
                            }));
                  }),
                  IconButton(
                      icon: new Icon(
                        Icons.undo,
                        color: Colors.red,
                        size: 28,
                      ),
                      tooltip: 'Undo',
                      onPressed: () {
                        if (_controller.isEmpty) {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  new Text('Nothing to undo'));
                        } else {
                          _controller.undo();
                        }
                      }),
                ],
              ),
            ),
            Positioned(
              top: 10,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: actions,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _show(PictureDetails picture, BuildContext context) async {
    setState(() {
      _finished = true;
    });
    await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        // appBar: new AppBar(
        //   title: const Text('View your image'),
        // ),
        body: Stack(children: [
          new Container(
            alignment: Alignment.center,
            child: new FutureBuilder<Uint8List>(
              future: picture.toPNG(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return Image.memory(snapshot.data!);
                    }
                  default:
                    return new Container(
                      child: new FractionallySizedBox(
                        widthFactor: 0.1,
                        child: new AspectRatio(
                            aspectRatio: 1.0,
                            child: new CircularProgressIndicator()),
                        alignment: Alignment.center,
                      ),
                    );
                }
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () async {
                        var aa = await picture.toPNG();
                        // var filee = await File.fromRawPath(aa);

                        // var image = MemoryImage(aa);
                        var aate = DateTime.now().toString();
                        final Directory systemTempDir = Directory.systemTemp;
                        final File file = await new File(
                                '${systemTempDir.path}/foo${aate}.png')
                            .create();
                        file.writeAsBytes(aa);

                        print(file);
                        await uploadImageToFirebase(file);
                        final snackBar = SnackBar(
                          content: Text('Yay! Your Mural is posted!'),
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.red,
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      },
                      child: Text('Post Mural')),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                  size: 32,
                ),
                tooltip: 'back',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ]),
      );
    }));

    Navigator.of(context).pop();
  }
}

// class DrawBar extends StatelessWidget {
//   final PainterController _controller;

//   DrawBar(this._controller);

//   @override
//   Widget build(BuildContext context) {
//     return new Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         new Flexible(child: new StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           return new Container(
//               child: new Slider(
//             value: _controller.thickness,
//             onChanged: (double value) => setState(() {
//               _controller.thickness = value;
//             }),
//             min: 1.0,
//             max: 20.0,
//             activeColor: Colors.white,
//           ));
//         })),
//         new StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           return new RotatedBox(
//               quarterTurns: _controller.eraseMode ? 2 : 0,
//               child: IconButton(
//                   icon: new Icon(Icons.create),
//                   tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
//                       ' eraser',
//                   onPressed: () {
//                     setState(() {
//                       _controller.eraseMode = !_controller.eraseMode;
//                     });
//                   }));
//         }),
//         new ColorPickerButton(_controller, false),
//         new ColorPickerButton(_controller, true),

//       ],
//     );
//   }
// }

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(80),
    //       border: Border.all(width: 2, color: Colors.white)),
    //   child: new IconButton(
    //       padding: EdgeInsets.zero,
    //       icon: new Icon(
    //         _iconData,
    //         color: _color,
    //       ),
    //       tooltip: widget._background
    //           ? 'Change background color'
    //           : 'Change draw color',
    //       onPressed: _pickColor),
    // );
    return Material(
        type: MaterialType
            .transparency, //Makes it usable on any background color, thanks @IanSmith
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            //This keeps the splash effect within the circle
            borderRadius: BorderRadius.circular(
                1000.0), //Something large to ensure a circle
            onTap: _pickColor,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                _iconData,
                color: _color,
                size: 28,
              ),
            ),
          ),
        ));
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(
      new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Pick color'),
            ),
            body: new Container(
              alignment: Alignment.center,
              child: new ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (Color c) => pickerColor = c,
              ),
            ),
          );
        },
      ),
    )
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.circle_sharp : Icons.circle_sharp;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
