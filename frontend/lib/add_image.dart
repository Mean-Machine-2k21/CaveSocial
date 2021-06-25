import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  ImagePicker _imagePicker = ImagePicker();
  File? image;

  Future<void> uploadImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
    });
    await uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    //String fileName = basename(_image.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/profileImages');
    final uploadTask = firebaseStorageRef.putFile(image!);
    await uploadTask.whenComplete(() => print('File Uploaded'));
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        // _uploadedFileURL = fileURL;
        // //imageURLs.add(_uploadedFileURL);
        // widget.product.imageUrls.add(_uploadedFileURL);
        print(fileURL + "-------");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image Uploaded'),
          ),
        );
      });
      // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      // taskSnapshot.ref.getDownloadURL().then(
      //       (value) => print("Done: $value"),
      //     );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      image: DecorationImage(
                          image: FileImage(image!), fit: BoxFit.cover),
                    ),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                uploadImage().then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile Photo Updated'),
                    ),
                  ),
                );
              },
              child: Text('ADD PROFILE IMAGE'),
            )
          ],
        ),
      ),
    );
  }
}
