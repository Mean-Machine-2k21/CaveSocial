import 'package:flutter/material.dart';
import 'package:frontend/bloc/theme_bloc.dart';

import 'models/app_text_style.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ThemeBloc color = ThemeBloc();
AppTextStyle style = AppTextStyle();
const SERVER_IP = 'https://cavesocial.herokuapp.com';
final storage = FlutterSecureStorage();
String colorString(Color colorValue) {
  return colorValue.toString().substring(10, 16);
}

void localInsertLoginIn(Map jwt) async {
  await storage.write(key: "jwt", value: jwt['token']);
  await storage.write(key: "userid", value: jwt['user']['_id']);
  await storage.write(key: "username", value: jwt['user']['username']);
  await storage.write(key: "avatar_url", value: jwt['user']['avatar_url']);
  await storage.write(key: "bio_url", value: jwt['user']['bio_url']);
}

void localInsertSignUp(Map jwt) {
  storage.write(key: "jwt", value: jwt['token']);
  storage.write(key: "userid", value: jwt['user']['_id']);
  storage.write(key: "username", value: jwt['user']['username']);
  storage.write(
      key: "avatar_url",
      value:
          'data:image/png;base64,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');
  storage.write(
      key: "bio_url",
      value:
          'https://designshack.net/wp-content/uploads/background-textures.png');
}

void localDelete() async {
  await storage.deleteAll();
}

Future<String> localRead(keyname) async {
  return await storage.read(key: keyname);
}

Future<void> localWrite(keyname, value) async {
  await storage.write(key: keyname, value: value);
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
