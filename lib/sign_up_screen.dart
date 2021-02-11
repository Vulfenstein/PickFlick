import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/swipe_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // ----------------------------------------------------------------------------//
//  variables
// ----------------------------------------------------------------------------//
  final _auth = FirebaseAuth.instance;
  String value;
  String email;
  String password;
  String e;

// ----------------------------------------------------------------------------//
//  Build background color gradient
// ----------------------------------------------------------------------------//
  _backgroundBuilder() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            //lightblue
            Color(0xFF2e4d5e),
            Color(0xFF14575d),
            Color(0xFF36aaa8),
          ],
        ),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Sign up message at top of screen
// ----------------------------------------------------------------------------//
  _signUpTextBuilder() {
    return Text(
      "Sign Up",
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Ubuntu-Regular',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  'email' + email text box
// ----------------------------------------------------------------------------//
  _emailBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.black,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.white, width: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (value) {
                email = value;
              },
            )),
      ],
    );
  }

// ----------------------------------------------------------------------------//
//  'password' + password text box
// ----------------------------------------------------------------------------//
  _passwordBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.black,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.white, width: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (value) {
                password = value;
              },
            )),
      ],
    );
  }

// ----------------------------------------------------------------------------//
//  Invalid email alert box
// ----------------------------------------------------------------------------//
  _emailInvalidAlert(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Format"),
      content: Text("Please enter a valid email address."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // ----------------------------------------------------------------------------//
//  weak password alert box
// ----------------------------------------------------------------------------//
  _badPasswordAlert(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Password too weak"),
      content: Text("Please enter a stronger password."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // ----------------------------------------------------------------------------//
//  email already in use alert box
// ----------------------------------------------------------------------------//
  _emailInUseAlert(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget forgotButton = FlatButton(
      child: Text("Forgot Password"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email already in use"),
      content: Text("Forgot password?"),
      actions: [
        forgotButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// ----------------------------------------------------------------------------//
//  Sign up using password and email
// ----------------------------------------------------------------------------//
  _firebaseLogin() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (newUser != null) {
        Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new SwipeScreen();
        },),);
      }
    } catch(e){
      if(e.code == "ERROR_INVALID_EMAIL"){
        _emailInvalidAlert(context);
      }
      else if(e.code == "ERROR_WEAK_PASSWORD"){
        _badPasswordAlert(context);
      }
      else if(e.code == "ERROR_EMAIL_ALREADY_IN_USE"){
        _emailInUseAlert(context);
      }
      print(e);
    }
  }

  // ----------------------------------------------------------------------------//
//  'email' + email text box
// ----------------------------------------------------------------------------//
  _signUpButtonBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          _firebaseLogin();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Sign up Screen builder
// ----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundBuilder(),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 100.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _signUpTextBuilder(),
                  SizedBox(height: 50.0),
                  _emailBuilder(),
                  SizedBox(height: 10.0),
                  _passwordBuilder(),
                  _signUpButtonBuilder(),
                  SizedBox(height: 15.0),
                  SizedBox(height: 110.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
