import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/logger.dart';

import '../global.dart';

enum ThemeEvent { dark, light }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc()
      : super(ThemeData(
          backgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.grey[900],
          ),
        ));

  ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    backgroundColor: Colors.black,
  );

  ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    backgroundColor: Colors.white,
  );

  static const Color _defaultMain = Colors.white;
  static const Color _defaultContrast = Color(0xFF1E1E2A);
  bool darkMode = false;
  static const Color _style = Color(0xFFFF3E3E);
  static const Color _alternative = Color(0xFF3D5AF1);
  Color get main => (darkMode) ? (_defaultContrast) : (_defaultMain);

  Color get contrast => (darkMode) ? (_defaultMain) : (_defaultContrast);

  Color get style => _style;

  Color get alternative => _alternative;

  Color get plain => Colors.transparent;

  Color get light => _defaultMain;

  Color get dark => _defaultContrast;

  Color get white => Colors.white;

  Color get black => Colors.black;

  MaterialColor get materialStyle => _materialStyle;
  static const MaterialColor _materialStyle = MaterialColor(
    0xFFFF3E3E,
    <int, Color>{
      50: Color(0xFFFFE6E6),
      100: Color(0xFFFFCECE),
      200: Color(0xFFFFABAB),
      300: Color(0xFFFF8E8E),
      400: Color(0xFFFF6565),
      500: Color(0xFFFF3E3E),
      600: Color(0xFFFF1313),
      700: Color(0xFFEC0000),
      800: Color(0xFFC10000),
      900: Color(0xFF980000),
    },
  );

  bool get isDarkMode => darkMode;

  bool get isLightMode => !(darkMode);

  T chooser<T>({required T lightMode, required T darkMode}) {
    if (darkMode == true) {
      return darkMode;
    } else {
      return lightMode;
    }
  }

  ThemeEvent currentTheme = ThemeEvent.dark;
  ThemeEvent get currentThemeEnum => currentTheme;

  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.dark:
        {
          currentTheme = ThemeEvent.dark;
          // ColorPalette.changefont(darkTheme.backgroundColor);
          darkMode = true;

          yield darkTheme;
        }
        break;
      case ThemeEvent.light:
        {
          currentTheme = ThemeEvent.light;
          //ColorPalette.changefont(darkTheme.backgroundColor);
          darkMode = false; //To see some change
          yield lightTheme;
        }
        break;

      default:
        break;
    }
  }

  void toggleTheTheme() async {
    print(currentTheme);
    add(currentTheme == ThemeEvent.dark ? ThemeEvent.light : ThemeEvent.dark);

    
     await storage.write(
                                  key: "darkThemeOn", value: currentTheme == ThemeEvent.dark ?"false":"true");
                              print('trueeeeeeeeeeeeeeeeeeeee');

     logger.e(await localRead("darkThemeOn"));
    
  //  print(currentTheme);
  }
}
