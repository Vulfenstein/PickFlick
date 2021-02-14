import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/constants.dart';

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
          Color(BACKGROUND_COLOR_1),
          Color(BACKGROUND_COLOR_2),
          Color(BACKGROUND_COLOR_3),
        ],
      ),
    ),
  );
}

// ----------------------------------------------------------------------------//
//  Login/Signup message at top of screen
// ----------------------------------------------------------------------------//
textBuilder(String word) {
  return Text(
    '$word',
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Ubuntu-Regular',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
}