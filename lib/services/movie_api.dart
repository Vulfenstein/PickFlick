import 'package:pick_flick/services/network.dart';
import 'package:pick_flick/utilities/constants.dart';

class MovieAPI {


  // THESE DON'T WORK
  Future<dynamic> getMovies() async{
    Network network = Network('$DISCOVER_URL$TMDB_V3');

    var movieData = await network.getData();
    return movieData;
  }

  Future<dynamic> getSingleMovie(String movieId) async {
    String temp = movieId;
    Network network = Network('$TMDB_V3');
    var singleData = await network.getData();
    return singleData;
  }

}
