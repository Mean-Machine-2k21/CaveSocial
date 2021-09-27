import 'dart:typed_data';

import 'package:image/image.dart';

List<int>? generateGIF(Iterable<Image> images) {
  final Animation animation = Animation();
  for (Image image in images) {
    animation.addFrame(image);
  }
  return encodeGifAnimation(animation);
}

final List<Image> images = [];

Future<void> addimage(Uint8List img) async {
  final PngDecoder decoder = PngDecoder();

  images.add(decoder.decodeImage(img)!);
}

int noofframes() {
  return images.length;
}

List<int> getgif() {
  List<int> gifData = generateGIF(images) ?? [];
  return gifData;
}

Future<void> undo() {
  images.removeLast();
  return Future.value();
}

void clear() {
  images.clear();
}
