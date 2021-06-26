import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../services/api_handling.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editProfile';
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  void getUrl(String bioUrl) {
    this.bioUrl = bioUrl;
    print("*******-> ${bioUrl}");
  }

  ApiHandling apiHandling = ApiHandling();
  ImagePicker _imagePicker = ImagePicker();
  String avatarUrl = "";
  String bioUrl = "";
  File? image;
  bool loading = false;

  Future<void> uploadImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
    });
    await uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    setState(() {
      loading = true;
    });

    String username = await localRead('username');
    //String fileName = basename(_image.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/profileImages/username');
    final uploadTask = firebaseStorageRef.putFile(image!);
    await uploadTask.whenComplete(() => print('File Uploaded'));
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        // _uploadedFileURL = fileURL;
        // //imageURLs.add(_uploadedFileURL);
        // widget.product.imageUrls.add(_uploadedFileURL);
        print(fileURL + "-------");
        avatarUrl = fileURL;
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

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Edit Your Profile!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            image != null
                ? Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      image: DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      ),
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
              child: Text(
                'ADD PROFILE IMAGE',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMuralScreen(
                      'normal',
                      editProfile: getUrl,
                    ),
                  ),
                );

                setState(() {
                  loading = false;
                });

                print('################ ${bioUrl}');
              },
              child: Text(
                'Create Bio',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await apiHandling.editProfile(
                  avatarUrl: avatarUrl,
                  bioUrl: bioUrl,
                );
                Navigator.of(context).pop();
              },
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
