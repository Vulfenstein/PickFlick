import 'package:flutter/material.dart';
import 'package:pick_flick/bloc/trailer_bloc.dart';
import 'package:pick_flick/models/movie_detail.dart';
import 'package:pick_flick/models/movie_trailer.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pick_flick/bloc/individual_movie_bloc.dart';
import  'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/utilities/api_helper_functions.dart';
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
  var detail;
  var movieTrailer;
  IndividualMovieBloc _bloc;
  MovieTrailerBloc trailerbloc;

  void initState() {
    super.initState();
    _bloc = IndividualMovieBloc(widget.movieId);
    trailerbloc = MovieTrailerBloc(widget.movieId);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _bloc.dispose();
    trailerbloc.dispose();
    super.dispose();
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
              BackgroundBuilder(),
              Container(
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: 735.2,
                    child: StreamBuilder<ApiResponse<MovieDetail>>(
                      stream: _bloc.movieStream,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          switch(snapshot.data.status){
                            case Status.LOADING:
                              return Loading();
                            case Status.COMPLETED:
                                VideoPlayer();
                                return MovieInformation(movieInfo: snapshot.data.data, bloc: trailerbloc,);
                            case Status.ERROR:
                              return Error(
                                errorMessage: snapshot.data.message,
                                onRetryPressed: () => _bloc.fetchMovieInformation(widget.movieId),
                              );
                              break;
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ]
        )
    );
  }
}

class MovieInformation extends StatelessWidget{

  final MovieDetail movieInfo;
  final MovieTrailerBloc bloc;

  const MovieInformation({Key key, this.movieInfo, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VideoPlayer(movie: movieInfo, bloc: bloc,),
        SizedBox(height: 20.0),
        TitleBuilder(name: movieInfo.title),
        SizedBox(height: 7.0),
        RatingBuilder(voteAverage: movieInfo.voteAverage),
        SizedBox(height: 10.0),
        RuntimeBuilder(runTime: movieInfo.runtime),
        SizedBox(height: 10.0),
        ReleaseDateBuilder(releaseDate: movieInfo.releaseDate),
        SizedBox(height: 15.0),
        OverviewBuilder(overview: movieInfo.overview),
      ],
    );
  }
}

// ignore: must_be_immutable
class VideoPlayer extends StatelessWidget {

  final MovieTrailerBloc bloc;
  final MovieDetail movie;
  YoutubePlayerController _controller;

  VideoPlayer({Key key, this.bloc, this.movie}) : super(key: key);

  Widget build(BuildContext context){
    return StreamBuilder<ApiResponse<MovieTrailer>> (
      stream: bloc.movieTrailerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _controller = YoutubePlayerController(
              initialVideoId: snapshot.data.data.results[0].key,
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
            IMAGEURL + movie.posterPath,
            height: 400.0,
            width: 400.0,
            fit: BoxFit.fill,
          );
        }
        return Container(child: Text("gegefe"),);
      },
    );
  }
}

