import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/networks/firebase.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // ----------------------------------------------------------------------------//
//  Variables
// ----------------------------------------------------------------------------//
  String value; // temp holder
  String email;
  String password;
  var movieData;

// ----------------------------------------------------------------------------//
//  Email text field
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
            ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------------------//
//  password text field
// ----------------------------------------------------------------------------//
  //Constructs password box
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
            ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------------------//
//  forgot password text & link
// ----------------------------------------------------------------------------//
  _forgotPasswordBuilder() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new PasswordScreen();
        },),),
        padding: EdgeInsets.only(right: 5.0),
        child: Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Log in button
// ----------------------------------------------------------------------------//
  _loginButtonBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          if(userCredential != null){
              Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new Home();
            },),);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          "LOGIN",
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
//  Google Login button
// ----------------------------------------------------------------------------//
  _googleLoginBuilder(){
    return Container(
      child: OutlineButton(
        splashColor: Colors.white,
        onPressed: () async{
          signInWithGoogle();
          if(FirebaseAuth.instance.currentUser != null){
            Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new Home();
            },),);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        borderSide: BorderSide(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------//
// Twitter login button
// ----------------------------------------------------------------------------//
  _twitterLoginBuilder() {
    return Container(
      child: OutlineButton(
        splashColor: Colors.white,
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        highlightElevation: 0,
        color: Colors.transparent,
        borderSide: BorderSide(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/twiiter_logo.png"),
                height: 28.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Sign in with Twitter",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------//
//  Sign up for new account text + link
// ----------------------------------------------------------------------------//
  _accountSignUpBuilder(){
    return GestureDetector(
      onTap:() => Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new SignUpScreen();
      },),),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don\'t have an account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            TextSpan(
              text: " Sign Up",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------//
//  login_screen.dart build method
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
                  textBuilder('Sign In'),
                  SizedBox(height: 10.0),
                  _emailBuilder(),
                  SizedBox(height: 10.0),
                  _passwordBuilder(),
                  _forgotPasswordBuilder(),
                  _loginButtonBuilder(),
                  _googleLoginBuilder(),
                  SizedBox(height: 15.0),
                  _twitterLoginBuilder(),
                  SizedBox(height: 110.0),
                  _accountSignUpBuilder(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
