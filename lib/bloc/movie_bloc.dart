import 'package:pick_flick/utilities/api_helper_functions.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/repository/movie_repository.dart';
import 'dart:async';

class MovieBloc {

  int curGenre;

  MovieRepository _movieRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<List<Movie>>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<List<Movie>>> get movieListStream =>
      _movieListController.stream;

  MovieBloc() {
    _movieListController = StreamController<ApiResponse<List<Movie>>>();
    _movieRepository = MovieRepository();
    fetchMovieList();
  }

  fetchMovieList() async {
    movieListSink.add(ApiResponse.loading('Fetching Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchMovieList();
      movieListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchNextPage() async {
    movieListSink.add(ApiResponse.loading('Fetching more Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchNextPage();
      movieListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchGenreList(int genreID) async {
    curGenre = genreID;
    movieListSink.add(ApiResponse.loading('Fetching Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchGenreList(curGenre);
      movieListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchGenreNextPage() async {
    movieListSink.add(ApiResponse.loading('Fetching more Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchGenreNextPage(curGenre);
      movieListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieListController?.close();
  }
}