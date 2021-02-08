import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  //variables
  var _check_value = false;

  // Constructs Background
  _backgroundBuilder() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [

            //BLUE
            // Color(0xFFbec4f8),
            // Color(0xFF6a6dde),
            // Color(0xFF6a6dde),
            // Color(0xFF4d42cf),
            // Color(0xFF713d90),

            //RED
            // Color(0xFFaf0704),
            // Color(0xFFb62810),
            // Color(0xFFbc3f09),
            // Color(0xFFc58b0e),

            //lightblue
            Color(0xFF2e4d5e),
            Color(0xFF14575d),
            Color(0xFF36aaa8),

          ],
        ),
      ),
    );
  }

  // Constructs Sign In
  _signInBuilder() {
    return Text(
      "Sign In",
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Ubuntu-Regular',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Constructs Email Box
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
            )),
      ],
    );
  }

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
            )),
      ],
    );
  }

  _forgotPasswordBuilder() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("implement forgot password page"),
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

  _loginBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print("implement login button"),
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

  _googleLoginBuilder(){
    return Container(
      child: OutlineButton(
        splashColor: Colors.white,
        onPressed: () => print("implement google button"),
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

  _accountSignUpBuilder(){
    return GestureDetector(
      onTap:() => print("implement sign up"),
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
                  _signInBuilder(),
                  SizedBox(height: 10.0),
                  _emailBuilder(),
                  SizedBox(height: 10.0),
                  _passwordBuilder(),
                  _forgotPasswordBuilder(),
                  _loginBuilder(),
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
