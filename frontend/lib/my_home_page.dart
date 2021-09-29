import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/global.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/navigator_screen.dart';
import 'package:frontend/services/logger.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/create_mural_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  static const routeName = '/homePage';

  var tokenValue, darkThemeOn;
  Future readToken() async {
    try {
      tokenValue = await localRead("jwt");
      logger.i("jadu hua jadu hua" + tokenValue);

      // try {
      //   darkThemeOn = await localRead("darkThemeOn");
      // } catch (e) {
      //   darkThemeOn = "false";
      // }
    } catch (e) {
      logger.i("jadu nhi hua jadu nhi hua");
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
    logger.i("chalega ????");

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
