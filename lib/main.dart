import 'package:flutter/material.dart';
import 'package:pick_flick/swipeScreen.dart';
import 'package:pick_flick/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
        '/login': (context) => loginScreen(),
        '/swipeScreen': (context) => swipeScreen(),
      },

      title: "PickFlick",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.purple,
      ),
      home: loginScreen()
      ,

    );
  }
}
