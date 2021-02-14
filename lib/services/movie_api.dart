import 'package:http/http.dart' as http;
import 'dart:convert';

// ----------------------------------------------------------------------------//
//  Given url, retrieve movie information, return decoded JSON.
// ----------------------------------------------------------------------------//
class MovieAPI {

  MovieAPI(this.url);

  final String url;

  getData() async{
    http.Response response = await http.get(url);

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }

}