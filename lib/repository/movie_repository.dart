import 'package:pick_flick/networks/network.dart';
import 'package:pick_flick/models/movie_list_model.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/models/movie_detail.dart';

class MovieRepository {
  Network _helper = Network();

  //Movie List
  Future<List<Movie>> fetchMovieList() async {
    final response = await _helper.get("movie/popular?api_key=$API_KEY");
    return MovieResponse.fromJson(response).results;
  }

  //Individual movie details
  Future<MovieDetail> fetchMovieDetails(int id) async{
    final response = await _helper.get("movie/${id.toString()}?api_key=$API_KEY");
    return MovieDetail.fromJson(response);
  }
}
