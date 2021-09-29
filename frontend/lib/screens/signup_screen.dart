import 'dart:convert';

import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/repository/mural_repository.dart';
import 'package:frontend/screens/feed.dart';
import 'package:frontend/screens/navigator_screen.dart';
import 'package:frontend/widget/app_button.dart';

import '../bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';
// import '../import/icons.dart';
import 'package:http/http.dart' as http;
import 'auth_screen.dart';
import 'login_screen.dart';
//import '../model/app_route.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = '';
  bool isloading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocus = FocusNode();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();
  void initState() {
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: '');
    _emailFocus = FocusNode(canRequestFocus: true);
    _passwordFocus = FocusNode(canRequestFocus: true);
    _confirmPasswordFocus = FocusNode(canRequestFocus: true);
    setState(() {});
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var themeBloc = BlocProvider.of<ThemeBloc>(context);
    var muralBloc = BlocProvider.of<MuralBloc>(context);
    //   if(themeBloc.darkMode)setState(() {});

    // Future<int> attemptSignUp(String username, String password) async {
    //   var res = await http.post('$SERVER_IP/api/signup',
    //     headers: {
    //        'Content-Type':'application/json'

    //      },
    //       body: json.encode({"username": username, "password": password }));
    //   print('gggggggggggghhhhhhhhhhhh');
    //   print(res.body);
    //   return res.statusCode;
    // }

    MuralRepository _muralRepository = MuralRepository();

    Future<Map> attemptSignUp(String username, String password) async {
      var res = await http.post(Uri.parse("$SERVER_IP/api/signup"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"username": username, "password": password}));
      print('gggggggggggghhhhgggggggggggggggggggggghhhhhhhh');
      print(json.decode(res.body));
      if (res.statusCode == 201) return json.decode(res.body);

      print('res+' + res.statusCode.toString());

      return {'res': res.statusCode.toString()};
    }

    void displayDialog(context, title, text) => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text(title), content: Text(text)),
        );
    double height = MediaQuery.of(context).size.height;
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    //  themeBloc.add(ThemeEvent.change);
    print('hey');
    print(themeBloc.darkMode);
    print(themeBloc.main);
    print(themeBloc.style);
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context2, state) {
        print('ggggggggggg_____' + themeBloc.main.toString());
        //ThemeBloc.dispatch();
        return MaterialApp(
          theme: state,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: themeBloc.main,
            body: Form(
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
                              'Sign Up to your account',
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
                              borderSide:
                                  BorderSide(color: themeBloc.style, width: 2),
                            ),
                          ),

                          controller: _emailController,
                          // autofocus: _emailFocus,
                          // onSubmit: (_) {
                          //   _passwordFocus.requestFocus();
                          // },
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
                              borderSide:
                                  BorderSide(color: themeBloc.style, width: 2),
                            ),
                          ),

                          controller: _passwordController,
                          // autofocus: _emailFocus,
                          // onSubmit: (_) {
                          //   _passwordFocus.requestFocus();
                          // },
                        ),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        TextFormField(
                          style: TextStyle(color: themeBloc.contrast),
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            labelText: 'Confirm Password',
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
                              borderSide:
                                  BorderSide(color: themeBloc.style, width: 2),
                            ),
                          ),
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please retype password';
                            else if (_passwordController.text !=
                                _confirmPasswordController.text)
                              return 'Password didnt match';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        AppButton(
                            buttonText: 'Sign Up',
                            onTap: () async {
                              _formkey.currentState!.save();
                              if (_formkey.currentState!.validate()) {
                                print('success');
                                print(_passwordController.text);
                                print(_emailController.text);
                                var username = _emailController.text;
                                var password = _passwordController.text;

                                if (username.length < 4)
                                  displayDialog(context, "Invalid Username",
                                      "The username should be at least 4 characters long");
                                else if (password.length < 7)
                                  displayDialog(context, "Invalid Password",
                                      "The password should be at least 7 characters long");
                                else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  var jwt =
                                      await attemptSignUp(username, password);
                                  setState(() {
                                    isloading = false;
                                  });
                                  // if (res == 201)
                                  //   displayDialog(context, "Success",
                                  //       "The user was created. Log in now.");
                                  // else if (res == 400)
                                  //   displayDialog(
                                  //       context,
                                  //       "That username is already registered",
                                  //       "Please try to sign up using another username or log in if you already have an account.");
                                  // else {
                                  //   displayDialog(context, "Error",
                                  //       "An unknown error occurred.");
                                  // }
                                  print('ppppppp');
                                  print(jwt['res']);
                                  if (jwt['res'] == null) {
                                    localInsertSignUp(jwt);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                MuralBloc(_muralRepository),
                                            child: BlocProvider.value(
                                              value: themeBloc,
                                              child: NavigatorPage(),
                                            ),
                                          ),
                                          // builder: (context) =>
                                          //     NavigatorPage ()
                                        )); //To change path here
                                  } else {
                                    if (jwt['res'] == '400') {
                                      displayDialog(
                                          context,
                                          "That username is already registered",
                                          "Please try to sign up using another username or log in if you already have an account.");
                                    } else
                                      displayDialog(
                                          context,
                                          "An Error Occurred",
                                          "No account was found matching that username and password");
                                  }
                                }
                              }
                              //TODO
                            }),
                        SizedBox(
                          height: height * 0.17,
                        ),
                        AppButton(
                          buttonColor: themeBloc.style,
                          buttonText: 'Login',
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => BlocProvider.value(
                                    value: themeBloc,
                                    child: LoginScreen(),
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
          ),
        );
      },
    );
  }
}
