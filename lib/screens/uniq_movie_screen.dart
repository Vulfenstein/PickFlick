import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:pick_flick/utilities/helper_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pick_flick/networks/firebase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class MovieScreen extends StatefulWidget {
  int movieId;
  MovieScreen(this.movieId);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  YoutubePlayerController _controller;
  var detail;
  var movieTrailer;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

// ----------------------------------------------------------------------------//
//  Fetch detailed movie information
// ----------------------------------------------------------------------------//
  Future getData() async {
    var data = await getJson();
    detail = data;
    return detail;
  }

  // ignore: missing_return
  Future<Map> getJson() async {
    try {
      var url =
          MOVIE_URL + widget.movieId.toString() + API_ATTACHMENT + API_KEY;
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  // ----------------------------------------------------------------------------//
//  Fetch movie trailer information
// ----------------------------------------------------------------------------//
  Future getTrailerData() async {
    var data = await getTrailerJson();
    movieTrailer = data;
    print(movieTrailer);
    return movieTrailer;
  }

  // ignore: missing_return
  Future<Map> getTrailerJson() async {
    try {
      var url = MOVIE_URL +
          widget.movieId.toString() +
          TRAILER_URL +
          API_ATTACHMENT +
          API_KEY +
          "&language=en-US";
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

// ----------------------------------------------------------------------------//
//  Background color gradient
// ----------------------------------------------------------------------------//
  _backgroundBuilder() {
    return BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(BACKGROUND_COLOR_1),
        Color(BACKGROUND_COLOR_2),
        Color(BACKGROUND_COLOR_3),
      ],
    ));
  }

// ----------------------------------------------------------------------------//
//  Movie title
// ----------------------------------------------------------------------------//
  _titleBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        detail['title'],
        style: TextStyle(color: Colors.black, fontSize: 25.0),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Row for stars and number of ratings
// ----------------------------------------------------------------------------//
  _ratingBuilder() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: StarRating(
            rating: detail['vote_average'],
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
        Text(detail['vote_average'].toString() + 'k reviews'),
      ],
    );
  }

// ----------------------------------------------------------------------------//
//  Row for release date information
// ----------------------------------------------------------------------------//
  _releaseDateBuilder() {
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
            detail['release_date'],
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Row for movies runtime information
// ----------------------------------------------------------------------------//
  _runtimeBuilder() {
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
            durationToString(detail['runtime']),
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Movie description
// ----------------------------------------------------------------------------//
  _overviewBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        detail['overview'],
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

  // ----------------------------------------------------------------------------//
//  Like and dislike buttons
// ----------------------------------------------------------------------------//
  _likeDislikeBuilder(){
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 130.0),),
        IconButton(icon: new Icon(Icons.thumb_down_alt, size: 40.0,), onPressed: (){
          Navigator.pop(context);
        },),
        Padding(padding: EdgeInsets.only(left: 30.0),),
        IconButton(icon: new Icon(Icons.thumb_up_alt, size: 40.0,), onPressed: (){
          uniqueMovieAdd(detail['id'], detail['poster_path']);
          Navigator.pop(context);
        },),
      ],
    );
  }

// ----------------------------------------------------------------------------//
//  Trailer widget
// ----------------------------------------------------------------------------//
_videoPlayer(){
  return FutureBuilder(
    future: getTrailerData(),
    builder: (context, snap) {
      if ((snap.connectionState == ConnectionState.done) && movieTrailer['results'][0]['key'] != null) {
        _controller = YoutubePlayerController(
            initialVideoId: movieTrailer['results'][0]['key'],
            flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ));
        return Container(
          width: 400.0,
          height: 420.0,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            onReady: (){},
          ),
        );
      } else {
        return Image.network(
          IMAGEURL + detail['poster_path'],
          height: 450.0,
          width: 400.0,
          fit: BoxFit.fill,
        );
      }
    },
  );
}

// ----------------------------------------------------------------------------//
//  Build Context
// ----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: _backgroundBuilder(),
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      height: 735.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _videoPlayer(),
                          SizedBox(height: 20.0),
                          _titleBuilder(),
                          SizedBox(height: 7.0),
                          _ratingBuilder(),
                          SizedBox(height: 10.0),
                          _runtimeBuilder(),
                          SizedBox(height: 10.0),
                          _releaseDateBuilder(),
                          SizedBox(height: 15.0),
                          _overviewBuilder(),
                          _likeDislikeBuilder(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
  );
}
