import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/screens/create_bio_screen.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/logger.dart';
import 'package:frontend/widget/shimmer_image.dart';
import 'package:frontend/widget/toggle_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../services/api_handling.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editProfile';
  final String bioUrl, avatarUrl;
  const EditProfile({Key? key, required this.bioUrl, required this.avatarUrl})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  void getUrl(String bioUrl) {
    this.bioUrl = bioUrl;
    print("***-> ${bioUrl}");
  }

  ApiHandling apiHandling = ApiHandling();
  ImagePicker _imagePicker = ImagePicker();
  String avatarUrl = "";
  String bioUrl = "";
  File? image;
  bool loading = false;
  bool pageLoading = false;

  String currentProfile = "";
  String currentBio = "";

  // void initState() {
  //   currentBio = widget.bioUrl;
  //   logger.i(currentBio);
  // }

  @override
  Future<void> didChangeDependencies() async {
    currentProfile = await localRead('avatar_url');
    currentBio = await localRead('bio_url');
    print('bioooo0000000000000000000000000000000000000000 $currentBio');
    bioUrl = currentBio;

    super.didChangeDependencies();
  }

  ApiHandling _apiHandling = ApiHandling();

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
    String time = DateTime.now().toString();
    //String fileName = basename(_image.path);
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/profileImages/${username}/${time}');
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
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        // return Center(
        //   child: CircularProgressIndicator(),
        // );
        // return pageLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        return Scaffold(
          backgroundColor: themeBloc.main,
          body: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Edit Your Profile !',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: themeBloc.contrast,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          await storage.write(
                            key: "avatar_url",
                            value: avatarUrl,
                          );
                          await storage.write(
                            key: "bio_url",
                            value: bioUrl,
                          );
                          await apiHandling.editProfile(
                            avatarUrl: avatarUrl,
                            bioUrl: bioUrl,
                          );
                          Navigator.of(context).pop();
                        },
                        child: loading
                            ? SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Icon(
                                Icons.save,
                                color: themeBloc.contrast,
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Profile Pictue',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: themeBloc.style),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            uploadImage().then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Profile Photo Updated'),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: themeBloc.style, //to expp
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       height: 95,
                    //       width: 95,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.red, width: 2),
                    //         shape: BoxShape.circle,
                    //         color: Colors.blue,
                    //         image: DecorationImage(
                    //           image: NetworkImage(currentProfile),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        image != null
                            ?
                            // CircularProgressIndicator(
                            //     color: themeBloc.contrast,
                            //     strokeWidth: 5.0,
                            //   )
                            Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                  image: DecorationImage(
                                    image: FileImage(image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                ),
                                child: ClipOval(
                                  child: Container(
                                    width: 95,
                                    height: 95,
                                    child:
                                        ShimmerNetworkImage(widget.avatarUrl),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Change Your Bio',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: themeBloc.style),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: themeBloc,
                                child: BlocProvider.value(
                                  value: muralBloc,
                                  child: CreateBioScreen(
                                    'normal',
                                    editProfile: getUrl,
                                  ),
                                ),
                              ),
                            ),
                          );

                          setState(() {
                            loading = false;
                          });

                          print('################ ');
                          localWrite('bio_url', bioUrl);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                bioUrl == ""
                    ? Container(
                        width: double.infinity,
                        height: 173,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          color: themeBloc.materialStyle.shade800,
                          // image: DecorationImage(
                          //   image: NetworkImage(bioUrl),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: ShimmerNetworkImage(widget.bioUrl),
                      )
                    : Container(
                        width: double.infinity,
                        height: 173,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          color: themeBloc.materialStyle.shade800,
                          // image: DecorationImage(
                          //   image: NetworkImage(bioUrl),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: ShimmerNetworkImage(bioUrl),
                      ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Toggle Color Mode',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: themeBloc.contrast),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Toggle(
                          value: themeBloc.isDarkMode,
                          onToggle: (val) async {
                            // if (value) {
                            //   // color.themeModeSwitch(colorMode: ColorMode.dark);
                            // } else {
                            //   // color.themeModeSwitch(colorMode: ColorMode.light);
                            themeBloc.toggleTheTheme();

                            // logger.d(themeBloc.isDarkMode);
                            // if (themeBloc.isDarkMode) {
                            //   await storage.write(
                            //       key: "darkThemeOn", value: "true");
                            //   print('trueeeeeeeeeeeeeeeeeeeee');
                            //   logger.e(await localRead("darkThemeOn"));
                            // } else {
                            //   await storage.write(
                            //       key: "darkThemeOn", value: "false");
                            //   print('falseeeeeeeeeeeeeeeeeeeeeeeee');
                            //   logger.e(await localRead("darkThemeOn"));
                            // }
                            // await storage.write(
                            //     key: "darkThemeOn",
                            //     value: themeBloc.isDarkMode ? "true" : "false");
                            // logger.d('ggez');
                            // logger.i(themeBloc.isDarkMode);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await _apiHandling.signOut();
                        localDelete();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                          (route) => false,
                        );

                        // Navigator.of(context)
                        //     .pushReplacementNamed(LoginScreen.routeName);
                      },
                      child: Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
