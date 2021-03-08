import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pick_flick/screens/login_screen.dart';
import 'package:pick_flick/utilities/login_errors.dart';

// ----------------------------------------------------------------------------//
//  Variables
// ----------------------------------------------------------------------------//
final _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
// var twitterLogin = new TwitterLogin(
//   consumerKey: '<token 1>',
//   consumerSecret: '<token 2>',
// );

// ----------------------------------------------------------------------------//
//  Attempt to log into firebase with registered account
// ----------------------------------------------------------------------------//
firebaseLogin(BuildContext context, String email, String password) async {
  try {
    final newUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (newUser != null) {
      return;
    }
  } catch (e) {
    if (e.code == 'ERROR_USER_NOT_FOUND' || e.code == "ERROR_INVALID_EMAIL") {
      emailNotFoundAlert(context);
    } else if (e.code == 'ERROR_WRONG_PASSWORD') {
      incorrectPasswordAlert(context);
    } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } catch (e) {
        print(e);
      }
      passwordLockAlert(context);
    }
    print(e);
  }
}

// ----------------------------------------------------------------------------//
//  Google authentication function
// ----------------------------------------------------------------------------//
signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  final User user =
      (await _firebaseAuth.signInWithCredential(credential)).user;
}

// ----------------------------------------------------------------------------//
//  Twitter authentication function
// ----------------------------------------------------------------------------//
_signInWithTwitter() async {
  //final TwitterLoginResult result = await twitterLogin.authorize();

  //final FirebaseUser user = (await _firebaseAuth.signInWithCredential(result)).user;
}

// ----------------------------------------------------------------------------//
//  Reset Password
// ----------------------------------------------------------------------------//
firebaseResetPassword(BuildContext context, String email) async {
  try {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    confirmationAlert(context);
  } catch (e) {
    if (e.code == "ERROR_INVALID_EMAIL") {
      emailInvalidAlert(context);
    } else if (e.code == "ERROR_USER_NOT_FOUND") {
      emailNotFoundAlert(context);
    }
  }
}

// ----------------------------------------------------------------------------//
//  Sign up using password and email
// ----------------------------------------------------------------------------//
firebaseSignup(context, String email, String password) async {
  try {
    final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (newUser != null) {
      Navigator.of(context).push(
        MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new LoginScreen();
          },
        ),
      );
    }
  } catch (e) {
    if (e.code == "ERROR_INVALID_EMAIL") {
      emailInvalidAlert(context);
    } else if (e.code == "ERROR_WEAK_PASSWORD") {
      badPasswordAlert(context);
    } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
      emailInUseAlert(context);
    }
    print(e);
  }
}
