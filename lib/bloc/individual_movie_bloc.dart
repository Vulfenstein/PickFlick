import 'package:pick_flick/utilities/api_response_status.dart';
import 'package:pick_flick/models/movie_detail.dart';
import 'package:pick_flick/repository/movie_repository.dart';
import 'dart:async';

class IndividualMovieBloc {
  MovieRepository _movieRepository;

  StreamController _movieController;

  StreamSink<ApiResponse<MovieDetail>> get movieSink =>
      _movieController.sink;

  Stream<ApiResponse<MovieDetail>> get movieStream =>
      _movieController.stream;

  IndividualMovieBloc(int id) {
    _movieController = StreamController<ApiResponse<MovieDetail>>();
    _movieRepository = MovieRepository();
    fetchMovie(id);
  }

  fetchMovie(int id) async {
    movieSink.add(ApiResponse.loading('Fetching Movie Details'));
    try {
      MovieDetail movie = await _movieRepository.fetchMovieDetails(id);
      movieSink.add(ApiResponse.completed(movie));
    } catch (e) {
      movieSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieController?.close();
  }
}