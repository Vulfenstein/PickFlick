import 'package:pick_flick/models/movie_trailer.dart';
import 'package:pick_flick/networks/network.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/models/movie_detail.dart';

class MovieRepository {
  int pagenum = 1;
  Network _helper = Network();

  //Popular Movie List
  Future<List<Movie>> fetchMovieList() async {
    pagenum = 1;
    final response = await _helper.get("movie/popular?api_key=$API_KEY");
    return MovieResponse.fromJson(response).results;
  }

  //Popular list next page
  Future<List<Movie>> fetchNextPage() async {
    pagenum++;
    final response = await _helper.get("movie/popular?api_key=$API_KEY&page=${pagenum.toString()}");
    return MovieResponse.fromJson(response).results;
  }

  //Genre movie list
  Future<List<Movie>> fetchGenreList(int genreID) async {
    pagenum = 1;
    final response = await _helper.get("movie/popular?api_key=$API_KEY&with_genres=${genreID.toString()}");
    return MovieResponse.fromJson(response).results;
  }

  //Genre list next page
  Future<List<Movie>> fetchGenreNextPage(int genreID) async {
    pagenum++;
    final response = await _helper.get("movie/popular?api_key=$API_KEY&with_genres=${genreID.toString()}&page=${pagenum.toString()}");
    return MovieResponse.fromJson(response).results;
  }

  //Individual movie details
  Future<MovieDetail> fetchMovieDetails(int id) async{
    final response = await _helper.get("movie/${id.toString()}?api_key=$API_KEY");
    return MovieDetail.fromJson(response);
  }

  //Movie trailer information
  Future<MovieTrailer> fetchMovieTrailer(int id) async{
    final response = await _helper.get("movie/${id.toString()}/videos?api_key=$API_KEY&language=en-US");
    return MovieTrailer.fromJson(response);
  }

}
