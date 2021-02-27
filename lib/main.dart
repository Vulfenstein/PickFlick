import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:pick_flick/screens/temp.dart';

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
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: new LoginScreen(),
    );
  }
}
//temp