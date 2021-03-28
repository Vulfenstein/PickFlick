import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:pick_flick/screens/login_screen.dart';

// ----------------------------------------------------------------------------//
//  Api error messages
// ----------------------------------------------------------------------------//
class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString(){
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String message])
      : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message])
      : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message])
      : super(message, "Invalid Input: ");
}

// ----------------------------------------------------------------------------//
//  Api response messages
// ----------------------------------------------------------------------------//
class ApiResponse<T> {
  Status status;
  T data;
  String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

//  Add liked movie id and poster to database
void addMovies(Movie movie) {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "Movie Details": FieldValue.arrayUnion([movie.id, movie.posterPath],),
  },SetOptions(merge: true)).then((_) {
    print("added");
  });
}

//  Add movie from unique page
void uniqMovieAdd(int id, String posterPath) {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "Movie Details": FieldValue.arrayUnion([id, posterPath],),
  },SetOptions(merge: true)).then((_) {
    print("added");
  });
}

// convert movie genre string to integer
int getVal(String genre){
  switch(genre){
    case 'Popular':
      return 0;
    case 'Action':
      return 28;
    case 'Comedy':
      return 35;
    case 'Drama':
      return 18;
    case 'Fantasy':
      return 14;
    case 'Horror':
      return 27;
    case 'Mystery':
      return 9648;
    case 'Romance':
      return 10749;
    case 'Thriller':
      return 53;
    default:
      return 0;
  }
}

//  Convert total minutes to hours and minutes.
String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
}

// Home screen top bar navigation handler
void topBarSelection(String selection) async{
  if(selection == 'Friends'){
    print("friends pressed");
  }
  else if(selection == 'Settings'){
    print("settings pressed");
  }
  else if(selection == "Log Out"){
    try{
      await FirebaseAuth.instance.signOut();
      new LoginScreen();
    }
    catch(e){
      print("error signing out");
    }
  }
}