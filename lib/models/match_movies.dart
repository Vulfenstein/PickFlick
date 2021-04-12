import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final List friends;
  final List<MatchedMovies> movieDetails;
  final String name;
  final List pendingFriends;

  UserInfo({this.friends, this.movieDetails, this.name, this.pendingFriends});


  UserInfo.fromSnapshot(DocumentSnapshot snapshot) :
      friends = snapshot.data()['Friends'],
      movieDetails = snapshot.data()['Movie Details'].map((item) {
        return MatchedMovies.fromMap(item);
      }).toList(),
      name = snapshot.data()['Name'],
      pendingFriends = snapshot.data()['Pending Friends'];

  Map<String, dynamic> movieAdd(int id, String poster){
    return {
      'Movie Details': FieldValue.arrayUnion([
        {
          "movieId": id,
          "posterId": poster,
        }
        ])
    };
  }
}

class MatchedMovies {
  final int movieId;
  final String posterId;

  MatchedMovies({this.movieId, this.posterId});

  MatchedMovies.fromMap(Map<String, dynamic> map) :
      movieId = map['movieId'],
      posterId = map['posterId'];

  Map<String, dynamic> movieAdd(int id, String poster){
    return {
      'Movie Details': FieldValue.arrayUnion([
        {
          "movieId": id,
          "posterId": poster,
        }
      ])
    };
  }
}