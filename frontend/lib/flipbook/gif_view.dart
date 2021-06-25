// @ dart=2.9;
import 'dart:io';
import 'dart:typed_data';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gifimage/flutter_gifimage.dart';

import 'functions.dart';

class GifView extends StatefulWidget {
  final int frames;
  final int time;
  GifView(this.frames, this.time);
  @override
  _GifViewState createState() => _GifViewState();
}

class _GifViewState extends State<GifView> with TickerProviderStateMixin {
  late var a;
  late var b;
  late GifController controller3;

  @override
  void initState() {
    a = getgif();
    b = Uint8List.fromList(a);

    print(widget.frames.toString() + 'adadadadad');
    // var aate = DateTime.now().toString();
    // final Directory systemTempDir = Directory.systemTemp;

    // final File file =
    //     await new File('${systemTempDir.path}/foo${aate}.png').create();
    // file.writeAsBytes(b);

    controller3 = GifController(
      vsync: this,
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller3.repeat(
          min: 0,
          max: widget.frames.toDouble(),
          period: Duration(milliseconds: widget.frames * widget.time));
    });
    super.initState();
  }

  @override
  void dispose() {
    controller3.dispose();
    super.dispose();
  }
  // GifController controller = GifController(vsync: this.controller);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Welcome to Flutter'),
        // ),
        body: Center(
            child: GifImage(
          controller: controller3,
          image: MemoryImage(b),
        )
            //  Image.memory(Uint8List.fromList(a)),
            ),
      ),
    );
  }
}
