import 'package:flutter/material.dart';
import 'package:pick_flick/screens/password_screen.dart';

// ----------------------------------------------------------------------------//
//  email is not found in firebase
// ----------------------------------------------------------------------------//
emailNotFoundAlert(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Email Not Found"),
    content: Text("Double check spelling."),
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
//  password is incorrect
// ----------------------------------------------------------------------------//
incorrectPasswordAlert(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget forgotButton = FlatButton(
    child: Text("Forgot Password?"),
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new PasswordScreen();
      },),);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Incorrect Password"),
    content: Text("Double check spelling."),
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
//  password becomes locked
// ----------------------------------------------------------------------------//
passwordLockAlert(BuildContext context){
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: (){
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Too many attempts"),
    content: Text("Link to reset password has been sent."),
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
//  invalid email alert box
// ----------------------------------------------------------------------------//
emailInvalidAlert(BuildContext context) {
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
//  Email sent for forgotten password
// ----------------------------------------------------------------------------//
confirmationAlert(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Email Sent"),
    content: Text("Follow steps provided in email."),
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
badPasswordAlert(BuildContext context) {
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
emailInUseAlert(BuildContext context) {
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
      Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new PasswordScreen();
      },),);
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
// movie searched for not found
// ----------------------------------------------------------------------------//
movieNotFound(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("No Results Found!"),
    content: Text("Double check spelling."),
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