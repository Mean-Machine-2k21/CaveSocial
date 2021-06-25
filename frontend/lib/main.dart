import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/create_mural_screen.dart';
import 'package:frontend/services/add_image.dart';

import 'screens/feed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Feed(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E1E2A),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // adding some properties
            showModalBottomSheet(
              context: context,

              // color is applied to main screen when modal bottom screen is displayed
              barrierColor: Colors.black.withOpacity(0.2),

              //background color for modal bottom screen
              backgroundColor: Color(0xff1E1E2A),
              //elevates modal bottom screen
              elevation: 100,
              // gives rounded corner to modal bottom screen
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                //  BorderRadius.circular(30.0),
              ),
              // isDismissible: true,
              builder: (BuildContext context) {
                return Container(
                  height: 150,

                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(200)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Choose Mode',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Normal',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExamplePage('normal')),
                                );
                                Navigator.pop(context);

                                ///
                                ///
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Comic',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExamplePage('comic')),
                                );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Color(0xffFF3E3E)),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Text(
                                  'Third',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Create Mural'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
