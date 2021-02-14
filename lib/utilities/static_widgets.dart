import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------//
//  Build background color gradient
// ----------------------------------------------------------------------------//
backgroundBuilder() {
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
//  Log in message at top of screen
// ----------------------------------------------------------------------------//
signInTextBuilder() {
  return Text(
    "Log In",
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Ubuntu-Regular',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

// ----------------------------------------------------------------------------//
//  Sign up message at top of screen
// ----------------------------------------------------------------------------//
signUpTextBuilder() {
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