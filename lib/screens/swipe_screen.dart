import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/screens/uniq_movie_screen.dart';
import 'package:pick_flick/services/movie_api.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SwipeScreen extends StatefulWidget {

  @override
  SwipeScreenState createState() {
    return new SwipeScreenState();
  }
}

class SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {
  var movies;
  var index;
  List<int> selectionIds = [];

  void getData() async {
    var data = await getJson();

    setState(() {
      movies = data['results'];
    });
  }

  Future<Map> getJson() async {
    try {
      var _apiKey = TMDB_V3;
      var url = URL + _apiKey;
      var response = await http.get(url);
      return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

//  // MovieList single = MovieList();
// void getMovieList() async{
//   var result = await MovieAPI().getMovies();
//   print(result);
//   setState(() {
//     movies = MovieList.fromJson(result);
//   });
// }
  void trackSelections(int value){
    print(value);
    try {
      selectionIds.add(value);
    }catch(e){
      print(e);
    }
  }

  // ----------------------------------------------------------------------------//
//  Constructs cards for swiping
// ----------------------------------------------------------------------------//
  _cardBuilding() {
    return Column(
      children: [
        Container(
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
            cardBuilder: (context, index) => FlatButton(
              child: Card(
                elevation: 20.0,
                child: Padding(
                  padding: EdgeInsets.all(1.5),
                  child: Image.network(
                    IMAGEURL + movies[index]['poster_path'],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new MovieScreen(movies[index]);
              },),),
            ),

            //Get orientation and index of swiped card
            swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
              var currentIndex = index;
              print("$currentIndex ${orientation.toString()}");
              if(orientation == CardSwipeOrientation.RIGHT){
                trackSelections(movies[index]['id']);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return new Scaffold(
      appBar: AppBar(
        title: Text("Pick Flick"),
      ),
      body: Stack(
        children: <Widget>[
          backgroundBuilder(),
          _cardBuilding(),
        ],
      ),
    );
  }
}