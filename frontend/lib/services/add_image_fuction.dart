import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future<String> uploadImageToFirebase(File image) async {
  //String fileName = basename(_image.path);

  String imageurl = "";

  String time = DateTime.now().toString();
  final firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/murals/mural${time}');

  await firebaseStorageRef.putFile(image);

  String url = await firebaseStorageRef.getDownloadURL();

  return url;
}
