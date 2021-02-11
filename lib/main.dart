import 'package:flutter/material.dart';
import 'package:pick_flick/password_screen.dart';
import 'package:pick_flick/swipe_screen.dart';
import 'package:pick_flick/login_screen.dart';
import 'package:pick_flick/sign_up_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/SwipeScreen': (context) => SwipeScreen(),
        '/SignUpScreen': (context) => SignUpScreen(),
        '/PasswordScreen': (context) => PasswordScreen(),
      },
      title: "PickFlick",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.purple,
      ),
      home: LoginScreen(),
    );
  }
}
//temp