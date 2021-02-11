import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/password_screen.dart';
import 'package:pick_flick/swipe_screen.dart';
import 'package:pick_flick/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // ----------------------------------------------------------------------------//
//  Variables
// ----------------------------------------------------------------------------//
  final _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var twitterLogin = new TwitterLogin(
    consumerKey: '<token 1>',
    consumerSecret: '<token 2>',
  );
  String value; // temp holder
  String email;
  String password;
  String e; //error checking

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
//  Log in message at top of screen
// ----------------------------------------------------------------------------//
  _signInTextBuilder() {
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
//  'password' + password box
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
            )),
      ],
    );
  }

  // ----------------------------------------------------------------------------//
//  'forgot password text + link'
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
//  Alert message if email is not found in firebase
// ----------------------------------------------------------------------------//
  _emailNotFoundAlert(BuildContext context) {
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
//  Alert message if password is incorrect
// ----------------------------------------------------------------------------//
  _incorrectPasswordAlert(BuildContext context) {
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
//  Alert message if password is incorrect
// ----------------------------------------------------------------------------//
  _resetPasswordAlert(BuildContext context){
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
//  Attempt to log into firebase with registered account
// ----------------------------------------------------------------------------//
  _firebaseLogin() async {
    try {
      final newUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (newUser != null) {
        Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new SwipeScreen();
        },),);
      }
    } catch(e){
      if(e.code == 'ERROR_USER_NOT_FOUND' || e.code == "ERROR_INVALID_EMAIL"){
        _emailNotFoundAlert(context);
      }
      else if(e.code == 'ERROR_WRONG_PASSWORD'){
        _incorrectPasswordAlert(context);
      }
      else if(e.code == 'ERROR_TOO_MANY_REQUESTS'){
        try {
          await _firebaseAuth.sendPasswordResetEmail(email: email);
        } catch(e){
          print(e);
        }
        _resetPasswordAlert(context);
      }
      print(e);
    }
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
          _firebaseLogin();
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
//  Sign in with Google function
// ----------------------------------------------------------------------------//
 _signInWithGoogle() async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
 }


  // ----------------------------------------------------------------------------//
//  Google Login button
// ----------------------------------------------------------------------------//
  _googleLoginBuilder(){
    return Container(
      child: OutlineButton(
        splashColor: Colors.white,
        onPressed: () async{
          _signInWithGoogle();
          if(await FirebaseAuth.instance.currentUser() != null){
            Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new SwipeScreen();
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
//  Google Login function
// ----------------------------------------------------------------------------//
  _signInWithTwitter() async{
    final TwitterLoginResult result = await twitterLogin.authorize();

    //final FirebaseUser user = (await _firebaseAuth.signInWithCredential(result)).user;
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
                  _signInTextBuilder(),
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
