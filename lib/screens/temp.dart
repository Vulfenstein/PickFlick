import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pick_flick/models/movie_detail.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pick_flick/bloc/individual_movie_bloc.dart';
import  'package:pick_flick/utilities/widgets.dart';

import 'file:///C:/Users/vulfe/AndroidStudioProjects/pick_flick/lib/utilities/api_response_status.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class MovieeScreen extends StatefulWidget {
  int movieId;
  MovieeScreen(this.movieId);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieeScreen> {
  YoutubePlayerController _controller;
  PaletteColor colors;
  var detail;
  var movieTrailer;
  IndividualMovieBloc _bloc;

  void initState() {
    super.initState();
    _bloc = IndividualMovieBloc(widget.movieId);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------------//
//  Get detailed movie data
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
      var response = await http.get(url);
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
//  Build title text
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
//  Builds rating row
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
//  Builds release date row
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
//  Builds runtime row
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
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Convert total minutes to hours and minutes.
// ----------------------------------------------------------------------------//
  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
  }

// ----------------------------------------------------------------------------//
//  Play youtube videos
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
              onReady: (){
                print("player ready");
              },
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Pick Flick',),
        ),
        body: Stack(
            children: <Widget>[
              backgroundBuilder(),
              StreamBuilder<ApiResponse<MovieDetail>>(
                stream: _bloc.movieListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Loading();
                      case Status.COMPLETED:
                        return MovieInfo(movieInfo: snapshot.data.data);
                    //return cardBuilder(movieList: snapshot.data.data);
                      case Status.ERROR:
                        return Error(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => _bloc.fetchMovie(widget.movieId),
                        );
                        break;
                    }
                  }
                  return Container();
                },
              )
            ]
        )

    );
  }
}

class MovieInfo extends StatelessWidget{

  final MovieDetail movieInfo;

  const MovieInfo({Key key, this.movieInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(movieInfo.title),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(errorMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 24),),
          SizedBox(height: 10,),
          RaisedButton(onPressed: onRetryPressed, color: Colors.blue,),
        ],
      ),
    );
  }
}