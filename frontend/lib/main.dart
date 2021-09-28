import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/logger.dart';

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
  logger.i('aaaaaaassssssssssssssss');
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
  @override
  Widget build(BuildContext context) {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);

    logger.i('aaaaaaaaaaaaaaaaaaaaaaa');
    logger.i(themeBloc.darkMode);

    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return MaterialApp(
          // theme: state,
          debugShowCheckedModeBanner: false,
          home: BlocProvider.value(
            value: themeBloc,
            child: BlocProvider.value(
              value: muralBloc,
              child: LoginScreen(),
            ),
          ),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
          },
        );
      },
    );
  }
}
