import 'package:pick_flick/networks/network.dart';
import 'package:pick_flick/models/movie_model.dart';
import 'package:pick_flick/utilities/constants.dart';

class MovieRepository {
  Network _helper = Network();

  Future<List<Movie>> fetchMovieList() async {
    final response = await _helper.get("movie/popular?api_key=$TMDB_V3");
    return MovieResponse.fromJson(response).results;
  }
}
