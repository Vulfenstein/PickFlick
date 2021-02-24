import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:pick_flick/utilities/utilities_export.dart';
import 'package:pick_flick/screens/uniq_movie_screen.dart';
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

  Future getData() async {
    var data = await getJson();
    movies = data['results'];
    return movies;
  }

  // ignore: missing_return
  Future<Map> getJson() async {
    try {
      var _apiKey = TMDB_V3;
      var url = DISCOVER_URL + _apiKey;
      var response = await http.get(url);
      return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

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
              cardBuilder: (context, index) => FlatButton(
                child: Card(
                  elevation: 100.0,
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Image.network(
                      IMAGEURL + movies[index]['poster_path'],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new MovieScreen(movies[index]['id']);
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
  if(snapshot.hasData) {
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
  else{
    return Center(child: CircularProgressIndicator());
  }
  },);
}