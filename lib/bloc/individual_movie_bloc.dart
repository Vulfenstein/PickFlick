import 'file:///C:/Users/vulfe/AndroidStudioProjects/pick_flick/lib/utilities/api_response_status.dart';
import 'package:pick_flick/models/movie_detail.dart';
import 'package:pick_flick/repository/movie_repository.dart';
import 'dart:async';

class IndividualMovieBloc {
  MovieRepository _movieRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<MovieDetail>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<MovieDetail>> get movieListStream =>
      _movieListController.stream;

  IndividualMovieBloc(int id) {
    _movieListController = StreamController<ApiResponse<MovieDetail>>();
    _movieRepository = MovieRepository();
    fetchMovie(id);
  }

  fetchMovie(int id) async {
    movieListSink.add(ApiResponse.loading('Fetching Movie Details'));
    try {
      MovieDetail movie = await _movieRepository.fetchMovieDetails(id);
      movieListSink.add(ApiResponse.completed(movie));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieListController?.close();
  }
}