import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:pick_flick/screens/temp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pick_flick/utilities/widgets.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Loading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          Widget test = new MediaQuery(data: MediaQueryData(), child: new MaterialApp(home: new LoginScreen()));
          return test;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}