// @dart=2.9;

import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/movie_search_service.dart';
import 'package:frontend/services/search_api.dart';

import '../bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';
import '../widget/app_button.dart';
import 'auth_screen.dart';
import 'feed.dart';
import 'movie_search_delegate.dart';
import 'navigator_screen.dart';
import 'signup_screen.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' show json, base64, ascii;

//import '../model/app_route.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  String _email = '';
  bool isloading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocus = FocusNode();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocus = FocusNode();

  void initState() {
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: '');
    _emailFocus = FocusNode(canRequestFocus: true);
    _passwordFocus = FocusNode(canRequestFocus: true);
    setState(() {});
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MuralRepository _muralRepository = MuralRepository();

    //   if(themeBloc.darkMode)setState(() {});

    Future<Map> attemptLogIn(String username, String password) async {
      var res = await http.post(Uri.parse("$SERVER_IP/api/login"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"username": username, "password": password}));
      print('gggggggggggghhhhgggggggggggggggggggggghhhhhhhh');
      print(json.decode(res.body));
      if (res.statusCode == 200) return json.decode(res.body);

      print('res+' + res.statusCode.toString());

      return {};
    }

    double height = MediaQuery.of(context).size.height;
    var themeBloc = BlocProvider.of<ThemeBloc>(context);

    //  themeBloc.add(ThemeEvent.change);
    print('heyyyyyyyyy');
    print(themeBloc.darkMode);
    print(themeBloc.main);
    print(themeBloc.style);
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context2, state) {
        print('ggggggggggg_____' + themeBloc.main.toString());
        //ThemeBloc.dispatch();
        return
            // MaterialApp(
            // theme: state,
            //home:
            Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: themeBloc.main,
          body: isloading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: themeBloc.contrast,
                    strokeWidth: 5,
                  ),
                )
              : Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Material(
                      color: themeBloc.plain,
                      child: ScreenPadding(
                        context: context,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.1,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Log into your account',
                                  style: style.heading
                                      .copyWith(color: themeBloc.contrast),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.07,
                            ),
                            TextFormField(
                              style: TextStyle(color: themeBloc.contrast),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: themeBloc.contrast,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: themeBloc.contrast.withOpacity(0.8),
                                  size: 25,
                                ),
                                hintStyle: TextStyle(
                                    color: themeBloc.contrast,
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'CircularStd'),
                                filled: true,
                                fillColor: themeBloc.plain,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: themeBloc.style, width: 2),
                                ),
                              ),
                              controller: _emailController,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextFormField(
                              style: TextStyle(color: themeBloc.contrast),
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: themeBloc.contrast,
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key_outlined,
                                  color: themeBloc.contrast.withOpacity(0.8),
                                  size: 25,
                                ),
                                hintStyle: TextStyle(
                                    color: themeBloc.contrast,
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'CircularStd'),
                                filled: true,
                                fillColor: themeBloc.plain,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: themeBloc.style, width: 2),
                                ),
                              ),
                              controller: _passwordController,
                            ),
                            SizedBox(
                              height: height * 0.07,
                            ),
                            AppButton(
                                buttonText: 'Login',
                                onTap: () async {
                                  _formkey.currentState!.save();
                                  if (_formkey.currentState!.validate()) {
                                    print('success');
                                    print(_passwordController.text);
                                    print(_emailController.text);

                                    var email = _emailController.text;
                                    var password = _passwordController.text;

                                    setState(() {
                                      isloading = true;
                                    });
                                    var jwt =
                                        await attemptLogIn(email, password);

                                    setState(() {
                                      isloading = false;
                                    });

                                    if (jwt.length != 0) {
                                      localInsertLoginIn(jwt);
                                      // storage.write(key: key, value: value)

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // HomePage.fromBase64(jwt['token'])
                                              //TODO
                                              BlocProvider(
                                            create: (context) =>
                                                MuralBloc(_muralRepository),
                                            child: BlocProvider.value(
                                              value: themeBloc,
                                              child: NavigatorPage(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      displayDialog(
                                          context,
                                          "An Error Occurred",
                                          "No account was found matching that username and password");
                                    }
                                    /////////////////////
                                  }
                                  //TODO
                                }),
                            SizedBox(
                              height: height * 0.17,
                            ),
                            AppButton(
                              buttonColor: themeBloc.style,
                              buttonText: 'Sign Up',
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => BlocProvider.value(
                                        value: themeBloc,
                                        child: SignUpScreen(),
                                      ),
                                    ));
                              },
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
        //   );
      },
    );
  }
}
