import 'package:pick_flick/models/movie_trailer.dart';
import 'package:pick_flick/networks/network.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/models/movie_detail.dart';

class MovieRepository {
  Network _helper = Network();

  //Popular Movie List
  Future<List<Movie>> fetchMovieList() async {
    final response = await _helper.get("movie/popular?api_key=$API_KEY");
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
