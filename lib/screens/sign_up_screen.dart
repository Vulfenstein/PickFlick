import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/screens/swipe_screen.dart';
import 'package:pick_flick/services/authentication.dart';
import 'package:pick_flick/utilities/static_widgets.dart';

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
//  'email' + email text box
// ----------------------------------------------------------------------------//
  _signUpButtonBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          firebaseSignup(context, email, password);
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
          backgroundBuilder(),
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
                  signUpTextBuilder(),
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
