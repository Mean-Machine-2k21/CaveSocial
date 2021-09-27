import 'dart:io';
import 'dart:typed_data';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gifimage/flutter_gifimage.dart';

class ShowFlipBook extends StatefulWidget {
  int? frames;
  int? time;
  final String flipbookUrl;
  ShowFlipBook(this.flipbookUrl, {this.frames, this.time});
  @override
  _ShowFlipBookState createState() => _ShowFlipBookState();
}

class _ShowFlipBookState extends State<ShowFlipBook>
    with TickerProviderStateMixin {
  late GifController controller3;

  @override
  void initState() {
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
          max: widget.frames!.toDouble(),
          period: Duration(milliseconds: widget.frames! * widget.time!));
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
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          controller: controller3,
          image: NetworkImage(widget.flipbookUrl),
        )
            //  Image.memory(Uint8List.fromList(a)),
            ),
      ),
    );
  }
}
