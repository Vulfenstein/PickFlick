import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/screens/uniq_movie_screen.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/utilities/constants.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List<dynamic> friends = [];
  List<dynamic> myMovies;
  var name;
  var mydata;

  void initState() {
    mydata = _getMyData();
    super.initState();
  }

  // Get current users fire store information
  _getMyData() async {
    await firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((snap) => {
              friends = snap["friends"],
              name = snap["name"],
              myMovies = snap["movies"],
            });
  }

  // Wait for user data, then load match list
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(BACKGROUND_COLOR_1),
            Color(BACKGROUND_COLOR_2),
            Color(BACKGROUND_COLOR_3),
          ]
        )
      ),
      child: Container(
        child: FutureBuilder(
            future: mydata,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Loading();
                case ConnectionState.done:
                  return MatchList(
                    friends: friends,
                    myMovies: myMovies,
                  );
                default:
                  return Loading();
              }
            }),
      ),
    );
  }
}

class MatchList extends StatelessWidget {
  final List<dynamic> friends;
  final List<dynamic> myMovies;
  final firestoreInstance = FirebaseFirestore.instance;

  MatchList({Key key, this.friends, this.myMovies}) : super(key: key);

  //For each friend in friends list, get friends movie likes
  _getFriendsMovies(String id) async {
    List<dynamic> friendsMovies = [];
    await firestoreInstance.collection("users").doc(id).get().then(
          (snap) => {
            friendsMovies = snap["movies"],
          },
        );
    return friendsMovies;
  }

  //Compare users liked movies and find friends that have the same matches
  _getMatches(List<dynamic> myMovies, List<dynamic> friendsMovie) {
    List<dynamic> matched = [];
    for (var i = 0; i < myMovies.length; i++) {
      if (friendsMovie.contains(myMovies[i])) {
        matched.add(myMovies[i]);
      }
    }
    return matched;
  }

  _getFriendsName(String id) async {
    var name;
    await firestoreInstance.collection("users").doc(id).get().then(
        (snap) => {
          name = snap["name"],
        }
    );
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: GridView.builder(
        itemCount: friends.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 2),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                FutureBuilder(
                  future: _getFriendsName(friends[index].toString()),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Loading();
                      case ConnectionState.done:
                        return Text(snapshot.data.toString(), style: TextStyle(color: Colors.white, fontSize: 14),);
                      default:
                        return Loading();
                    }
                  },
                ),
               // Text(friends[index], style: TextStyle(color: Colors.white),),
                Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                FutureBuilder(
                  future: _getFriendsMovies(friends[index].toString()),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Loading();
                      case ConnectionState.done:
                        List<dynamic> matches;
                        matches = _getMatches(myMovies, snapshot.data);
                        if (matches.isNotEmpty){
                          return Container(
                              height: 150,
                              child: Matches(movies: matches),
                          );
                        }
                        else{
                          return Text("No matches yet! Keep swiping!", style: TextStyle(color: Colors.white),);
                        }
                        return Text(snapshot.data.toString());
                      default:
                        return Loading();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Matches extends StatefulWidget{

  List<dynamic> movies;

  Matches({Key key, this.movies}) : super(key: key);

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  List<dynamic>movieInfo = [];

  Future getData() async {
    for(var i = 0; i < widget.movies.length; i++) {
      var data = await getJson(widget.movies[i].toString());
      movieInfo.add(data);
    }
    return movieInfo;
  }

  // ignore: missing_return
  Future<Map> getJson(String id) async {
    try {
      var url =
          MOVIE_URL + id.toString() + API_ATTACHMENT + API_KEY;
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Loading();
          case ConnectionState.done:
            return ListView.builder(
              itemCount: movieInfo.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Image.network(
                        IMAGEURL + movieInfo[index]['poster_path'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                    onTap: () async {
                     await Navigator.push(context, new MaterialPageRoute(builder: (context) => MovieScreen(movieInfo[index]['id'])));
                    }
                );
              },
            );
           // return Text(snapshot.data.toString());
          default:
            return Loading();
        }
      },
    );
  }
}
