import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future uploadGifToFirebase(File image) async {
  String time = DateTime.now().toString();
  final firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/murals/gif${time}');

  //final uploadTask = firebaseStorageRef.putFile(image);
  // await uploadTask.whenComplete(() => print('File Uploaded'));
  // firebaseStorageRef.getDownloadURL().then((fileURL) {
  //   print(fileURL + "-------");
  // });

  await firebaseStorageRef.putFile(image);

  String url = await firebaseStorageRef.getDownloadURL();

  return url;
}
