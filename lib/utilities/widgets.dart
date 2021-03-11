import 'package:flutter/material.dart';
import 'package:pick_flick/bloc/movie_bloc.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/api_helper_functions.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

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

//  Swipe card constructor
class CardBuilder extends StatelessWidget {
  final List<Movie> movies;

  const CardBuilder({Key key, this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: new TinderSwapCard(
              totalNum: movies != null ? movies.length : 0,
              stackNum: 3,
              orientation: AmassOrientation.TOP,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 2,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,

              // Construct new cards
              cardBuilder: (context, index) =>
                  OutlinedButton(
                    child: Card(
                      elevation: 100.0,
                      child: Padding(
                        padding: EdgeInsets.all(1.5),
                        child: Image.network(
                          IMAGEURL + movies[index].posterPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new MovieScreen(movies[index].id);
                          },),),
                  ),

              //Get orientation and index of swiped card
              swipeCompleteCallback: (CardSwipeOrientation orientation,
                  int index) {
                var currentIndex = index;
                print("$currentIndex ${orientation.toString()}");
                if (orientation == CardSwipeOrientation.RIGHT) {
                  addMovies(movies[index]);
                  print('hello');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

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
