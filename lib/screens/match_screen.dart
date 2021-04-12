import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/utilities/widgets.dart';

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

  void initState() {
    _getMyData();
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
      child: FutureBuilder(
          future: _getMyData(),
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: friends.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Text(friends[index]),
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
                    if (matches.isNotEmpty) print(matches);
                    return Text(snapshot.data.toString());
                  default:
                    return Loading();
                }
              },
            )
          ],
        );
      },
    );
  }
}
