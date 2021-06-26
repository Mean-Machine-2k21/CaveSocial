import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/theme_bloc.dart';
import 'global.dart';
import 'screens/login_screen.dart';
import 'package:frontend/screens/edit_profile.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:frontend/screens/create_post_screen.dart';

import 'flipbook/create_flipbook_frame.dart';
import 'flipbook/flipbook_create.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('aaaaaaassssssssssssssss');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);

    print('aaaaaaaaaaaaaaaaaaaaaaa');
    print(themeBloc.darkMode);

    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return MaterialApp(
          // theme: state,
          debugShowCheckedModeBanner: false,
          home:
              //LoginScreen(),
              Scaffold(
            backgroundColor:
                // themeBloc.currentThemeEnum == ThemeEvent.dark
                //     ? Colors.black
                //     : Colors.white,
                themeBloc.main,
            appBar: AppBar(
              title: Text(
                "hi",
                style: TextStyle(
                  color: color.contrast,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    themeBloc.toggleTheTheme();
                  },
                  icon: Icon(
                    themeBloc.currentTheme == ThemeEvent.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: themeBloc.currentTheme == ThemeEvent.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => BlocProvider.value(
                            value: themeBloc,
                            child: LoginScreen(),
                          ),
                        ));
                  },
                  child: Text('Kick Me'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MuralHome extends StatefulWidget {
  MuralHome({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MuralHomeState createState() => _MuralHomeState();
}

class _MuralHomeState extends State<MuralHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E1E2A),
      body: Center(
        child: 
        ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePostScreen(
                        title: 'Flipbook',
                      )),
            );
          },
          child: Text('Create Post'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
