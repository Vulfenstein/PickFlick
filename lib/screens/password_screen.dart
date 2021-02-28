import 'package:flutter/material.dart';
import 'package:pick_flick/screens/login_screen.dart';
import 'package:pick_flick/networks/authentication.dart';
import 'package:pick_flick/utilities/widgets.dart';

class PasswordScreen extends StatefulWidget {

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  // ----------------------------------------------------------------------------//
//  variables
// ----------------------------------------------------------------------------//
  String value;
  String email;
  String e;

// ----------------------------------------------------------------------------//
//  Sign up message at top of screen
// ----------------------------------------------------------------------------//
  _passwordTextBuilder() {
    return Text(
      "Forgot Password",
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
//  'email' + email text box
// ----------------------------------------------------------------------------//
  _enterButtonBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
         firebaseResetPassword(context, email);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          "Enter",
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
//  'email' + email text box
// ----------------------------------------------------------------------------//
  _returnButtonBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new LoginScreen();
          },),);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          "Return to Login",
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
          BackgroundBuilder(),
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
                  _passwordTextBuilder(),
                  SizedBox(height: 50.0),
                  _emailBuilder(),
                  SizedBox(height: 10.0),
                  _enterButtonBuilder(),
                  _returnButtonBuilder(),
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
