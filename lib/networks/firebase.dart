import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pick_flick/screens/login_screen.dart';
import 'package:pick_flick/utilities/error_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_flick/models/movie_list.dart';

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
firebaseSignup(context, String email, String password, String name) async {
  try {
    //create user
    final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //create initial user document
    final firestoreInstance = FirebaseFirestore.instance;
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("users").doc(firebaseUser.uid).set({
      "name": name,
      "pendingFriends": [],
      "friends": [],
      "friendsNames": [],
      "id": firebaseUser.uid,
      "hasFriends": false,
      "hasPending": false,
      "movies": [],
    },SetOptions(merge: true)).then((_) {
      print("initial document added");
    });

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

// ----------------------------------------------------------------------------//
// Add liked movie id and poster to database
// ----------------------------------------------------------------------------//
void addMovies(Movie movie) {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "movies": FieldValue.arrayUnion([movie.id],),
  },SetOptions(merge: true)).then((_) {
    print("swipe movie added");
  });
}

// ----------------------------------------------------------------------------//
// Add movie from unique page
// ----------------------------------------------------------------------------//
void uniqueMovieAdd(int id, String posterPath) {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "movies": FieldValue.arrayUnion([id],),
  },SetOptions(merge: true)).then((_) {
    print("swipe movie added");
  });
}

// ----------------------------------------------------------------------------//
// Send friend request (pending)
// ----------------------------------------------------------------------------//
void pendingFriendAdd(String friend){
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  print(friend);


  firestoreInstance.collection("users").doc(friend).set({
    "pendingFriends": FieldValue.arrayUnion([firebaseUser.uid],),
    "hasPending": true,
  },SetOptions(merge: true)).then((_) {
    print("pending friend 2 to 1");
  });
}

// ----------------------------------------------------------------------------//
// Accepted friend request (friends)
// ----------------------------------------------------------------------------//
void friendAdd(String friend){
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  //add to friends list for logged in user
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "hasFriends": true,
    "friends": FieldValue.arrayUnion([friend],),
  },SetOptions(merge: true)).then((_) {
    print("pending friend 1 to 2");
  });
  //add logged in user to other users friends list
  firestoreInstance.collection("users").doc(friend).set({
    "hasFriends": true,
    "friends": FieldValue.arrayUnion([firebaseUser.uid],),
  },SetOptions(merge: true)).then((_) {
    print("pending friend 2 to 1");
  });

  //remove from pending list
  firestoreInstance.collection("users").doc(firebaseUser.uid).update({
    "pendingFriends": FieldValue.arrayRemove([friend]),
  });
}

void chatCreation(String friendId){
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot> sub, sub2;
  final DocumentReference documentReference1 = firestoreInstance.collection("ChatRoom").doc(friendId + "_" + firebaseUser.uid);
  final DocumentReference documentReference2 = firestoreInstance.collection("ChatRoom").doc(firebaseUser.uid + "_" + friendId);

  List<Map<String, String>> messages = [{
    "messageContent" : "", "sender" : firebaseUser.uid, "time" : DateTime.now().toString(),
  }];

  sub = documentReference1.snapshots().listen((datasnapshot) async{
    if(datasnapshot.exists){
      print("Friend started chat");
    }
    else{
        sub2 = documentReference2.snapshots().listen((snap) async{
        if(snap.exists){
          print("You started chat");
        }
        else{
          firestoreInstance.collection("ChatRoom").doc(firebaseUser.uid + "_" + friendId).set({
            "user1" : firebaseUser.uid,
            "user2" : friendId,
            "messages": messages,
          });
        }
      });
    }
  });
}

void sendMessage(String friendId, String message){
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  List<Map<String, String>> newMessage = [{
    "messageContent": message, "sender" : firebaseUser.uid, "time" : DateTime.now().toString(),
  }];

  try {
    firestoreInstance.collection("ChatRoom").doc(
        firebaseUser.uid + "_" + friendId).update(
        {"messages": FieldValue.arrayUnion(newMessage)});
  }catch(e){
  }

  try{
    firestoreInstance.collection("ChatRoom").doc(friendId + "_" + firebaseUser.uid).update(
        {"messages" : FieldValue.arrayUnion(newMessage)});
  }catch(e){
  }

}