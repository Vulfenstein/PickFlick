import 'package:http/http.dart' as http;
import 'dart:convert';

// ----------------------------------------------------------------------------//
//  Given url, retrieve movie information, return decoded JSON.
// ----------------------------------------------------------------------------//
class Network {

  final String url;

  Network(this.url);

  Future getData() async{
    http.Response response = await http.get(url);

    if(response.statusCode == 200) {
      return response.body;
    }
    else{
      print(response.statusCode);
    }
  }
}
