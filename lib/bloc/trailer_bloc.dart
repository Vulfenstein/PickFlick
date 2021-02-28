import 'package:pick_flick/utilities/api_response_status.dart';
import 'package:pick_flick/models/movie_trailer.dart';
import 'package:pick_flick/repository/movie_repository.dart';
import 'dart:async';

class MovieTrailerBloc {
  MovieRepository _movieRepository;

  StreamController _movieController;

  StreamSink<ApiResponse<MovieTrailer>> get movieTrailerSink =>
      _movieController.sink;

  Stream<ApiResponse<MovieTrailer>> get movieTrailerStream =>
      _movieController.stream;

  MovieTrailerBloc(int id) {
    _movieController = StreamController<ApiResponse<MovieTrailer>>();
    _movieRepository = MovieRepository();
    fetchMovieTrailer(id);
  }

  fetchMovieTrailer(int id) async {
    movieTrailerSink.add(ApiResponse.loading('Fetching Movie Details'));
    try {
      MovieTrailer movie = await _movieRepository.fetchMovieTrailer(id);
      movieTrailerSink.add(ApiResponse.completed(movie));
    } catch (e) {
      movieTrailerSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }



  dispose() {
    _movieController?.close();
  }
}