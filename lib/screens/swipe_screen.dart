// Swipe stack
import 'package:flutter/material.dart';
import 'package:pick_flick/bloc/movie_bloc.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/api_helper_functions.dart';
import 'package:pick_flick/utilities/widgets.dart';

class MovieSwipe extends StatefulWidget {
  @override
  _MovieSwipeState createState() => _MovieSwipeState();
}

class _MovieSwipeState extends State<MovieSwipe> {
  MovieBloc _bloc;

  void initState() {
    _bloc = MovieBloc();
    super.initState();
  }

  void dispose(){
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          BackgroundBuilder(),
          StreamBuilder<ApiResponse<List<Movie>>>(
            stream: _bloc.movieListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Loading();
                  case Status.COMPLETED:
                    return CardBuilder(movies: snapshot.data.data);
                  case Status.ERROR:
                    print(snapshot.data.message);
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _bloc.fetchMovieList(),
                    );
                    break;
                }
              }
              return Container();
            },
          ),
        ]
    );
  }
}