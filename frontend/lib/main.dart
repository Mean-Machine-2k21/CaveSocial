import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/navigator_screen.dart';
import 'package:frontend/services/logger.dart';

import 'bloc/theme_bloc.dart';
import 'global.dart';
import 'screens/login_screen.dart';
import 'package:http/http.dart' as http;
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
  MuralRepository muralRepository = MuralRepository();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocProvider(
        create: (context) => MuralBloc(muralRepository),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  var tokenValue, darkThemeOn;
  Future readToken() async {
    try {
      tokenValue = await localRead("jwt");
      // try {
      //   darkThemeOn = await localRead("darkThemeOn");
      // } catch (e) {
      //   darkThemeOn = "false";
      // }
    } catch (e) {
      return tokenValue = " ";
    }
    return tokenValue;
  }

  Future readTheme() async {
    try {
      return darkThemeOn = await localRead("darkThemeOn");
    } catch (e) {
      return darkThemeOn = "false";
    }
    //return darkThemeOn;
  }

  Widget checkSync() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        if (tokenValue == " ") {
          return LoginScreen();
        } else {
          return BlocProvider(
            create: (context) => MuralBloc(MuralRepository()),
            //child:
            //value: themeBloc,
            child: NavigatorPage(),
          );
        }
      },
      future: readToken(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);

    //  print('%%%%%%%%%%%%' + (readTheme()).toString());
    print('aaaaaaaaaaaaaaaaaaaaaaa');

    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        if (darkThemeOn == "false") {
          logger.d(darkThemeOn);
          logger.e('should false');
             themeBloc.darkMode = false;
          return BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                // theme: state,
                debugShowCheckedModeBanner: false,
                home: BlocProvider.value(
                  value: themeBloc,
                  child: BlocProvider.value(
                    value: muralBloc,
                    child: checkSync(),
                  ),
                ),
                routes: {
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                },
              );
            },
          );
        } else {
           logger.i(darkThemeOn);
          logger.e('should false');
          themeBloc.darkMode = true;
          return BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                // theme: state,
                debugShowCheckedModeBanner: false,
                home: BlocProvider.value(
                  value: themeBloc,
                  child: BlocProvider.value(
                    value: muralBloc,
                    child: checkSync(),
                  ),
                ),
                routes: {
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                },
              );
            },
          );
        }
      },
      future: readTheme(),
    );

    // logger.e( localRead("darkThemeOn"));
    // print(themeBloc.darkMode);
    // themeBloc.darkMode = (darkThemeOn == "true") ? true : false;
    // print(themeBloc.darkMode);
  }
}
