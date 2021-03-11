import 'package:flutter/material.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ----------------------------------------------------------------------------//
//  Individual movie details functions
// ----------------------------------------------------------------------------//

//  Build background color gradient
class BackgroundBuilder extends StatelessWidget {
  Widget build(BuildContext context) {
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
}

//  Login/Signup message at top of screen
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

//  Build title text (Unique screen)
class TitleBuilder extends StatelessWidget {
  final String name;

  const TitleBuilder({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        name,
        style: TextStyle(color: Colors.black, fontSize: 25.0),
      ),
    );
  }
}

//  Builds rating row (Unique screen)
class RatingBuilder extends StatelessWidget {
  final double voteAverage;

  const RatingBuilder({Key key, this.voteAverage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: StarRating(
            rating: voteAverage,
            starConfig: StarConfig(
              size: 16.0,
              strokeColor: Colors.black54,
              fillColor: Colors.black54,
              emptyColor: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 13.0,
        ),
        Text(voteAverage.toString() + 'k reviews'),
      ],
    );
  }
}

//  Builds release date row (Unique screen)
class ReleaseDateBuilder extends StatelessWidget {
  final String releaseDate;

  const ReleaseDateBuilder({Key key, this.releaseDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.black54,
            size: 17.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            releaseDate,
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}

//  Builds runtime row (Unique screen)
class RuntimeBuilder extends StatelessWidget {
  final int runTime;

  const RuntimeBuilder({Key key, this.runTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: Colors.black54,
            size: 17.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            durationToString(runTime),
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}

//  Movie description (Unique screen)
class OverviewBuilder extends StatelessWidget {
  final String overview;

  const OverviewBuilder({Key key, this.overview}) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        overview,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }
}

//  Convert total minutes to hours and minutes.
String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
}

//  Returns loading circle
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

//  Error message when api breaks
class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: onRetryPressed,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------//
//  Movie Swipe Screen functions
// ----------------------------------------------------------------------------//

//  Add liked movie id to database
void addMovies(Movie movie) {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).set({
    "Movie Details": FieldValue.arrayUnion([movie.id, movie.posterPath],),
  },SetOptions(merge: true)).then((_) {
    print("added");
  });
}

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