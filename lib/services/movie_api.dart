import 'package:pick_flick/services/network.dart';
import 'package:pick_flick/utilities/constants.dart';

class MovieAPI {

  Future<dynamic> getMovies() async{
    Network network = Network('$URL$TMDB_V3');

    var movieData = await network.getData();
    return movieData;
  }

  Future<dynamic> getSingleMovie(String movieId) async {
    String temp = movieId;
    Network network = Network('$SMOVIEURL$TMDB_V3');
    var singleData = await network.getData();
    return singleData;
  }

}
