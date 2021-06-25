// @dart=2.9
import '../bloc/theme_bloc.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;

import '../global.dart';

class AuthScreen extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
      var themeBloc = BlocProvider.of<ThemeBloc>(context);

    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return BlocProvider.value(
                    value: themeBloc,
                    child:LoginScreen(),
                  );
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                 // return HomePage(str, payload);
                  return BlocProvider.value(
                    value: themeBloc,
                    child: HomePage(str, payload),
                  );
                } else {
                  return BlocProvider.value(
                    value: themeBloc,
                    child: LoginScreen(),
                  );
                }
              }
            } else {
              return BlocProvider.value(
                    value: themeBloc,
                    child: LoginScreen(),
                  );
            }
          }),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
              future:
                  http.read(Uri.parse('$SERVER_IP/data'), headers: {"Authorization": jwt}),
              builder: (context, snapshot) => snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Text("${payload['username']}, here's the data:"),
                        Text(snapshot.data,
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    )
                  : snapshot.hasError
                      ? Text("An error occurred")
                      : CircularProgressIndicator()),
        ),
      );
}
