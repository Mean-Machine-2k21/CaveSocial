import 'package:flutter/material.dart';
import 'package:frontend/bloc/theme_bloc.dart';

//import 'colors/color_palette.dart';
import 'model/app_text_style.dart';

//export 'import/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

 ThemeBloc color = ThemeBloc();
AppTextStyle style = AppTextStyle();
const SERVER_IP = 'https://cavesocial.herokuapp.com';
final storage = FlutterSecureStorage();
String colorString(Color colorValue) {
  return colorValue.toString().substring(10, 16);
}

void localInsertLoginIn(Map jwt) {
  storage.write(key: "jwt", value: jwt['token']);
  storage.write(key: "userid", value: jwt['user']['_id']);
  storage.write(key: "username", value: jwt['user']['username']);
  storage.write(key: "avatar_url", value: jwt['user']['avatar_url']);
  storage.write(key: "bio_url", value: jwt['user']['bio_url']);
}

void localInsertSignUp(Map jwt) {
  storage.write(key: "jwt", value: jwt['token']);
  storage.write(key: "userid", value: jwt['user']['_id']);
  storage.write(key: "username", value: jwt['user']['username']);
  // storage.write(key: "avatar_url", value: jwt['user']['avatar_url']);
  // storage.write(key: "bio_url", value: jwt['user']['bio_url']);
}

void localDelete() async {
  await storage.deleteAll();
}

Future<String> localRead(keyname) async {
  
  return  await storage.read(key: keyname); 
}

class ScreenPadding extends StatelessWidget {
  final BuildContext context;
  final Widget child;
  ScreenPadding({required this.context, required this.child});
  @override
  Widget build(BuildContext newContext) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).size.height * 0.05,
        left: MediaQuery.of(context).size.width * 0.11,
        right: MediaQuery.of(context).size.width * 0.11,
      ),
      child: child,
    );
  }
}
