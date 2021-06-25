import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future uploadImageToFirebase(File image) async {
  //String fileName = basename(_image.path);
  final firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/profileImages');
  var image;
  final uploadTask = firebaseStorageRef.putFile(image!);
  await uploadTask.whenComplete(() => print('File Uploaded'));
  firebaseStorageRef.getDownloadURL().then((fileURL) {
    // _uploadedFileURL = fileURL;
    // //imageURLs.add(_uploadedFileURL);
    // widget.product.imageUrls.add(_uploadedFileURL);
    print(fileURL + "-------");

    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    //     );
  });
}
