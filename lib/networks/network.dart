import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'file:///C:/Users/vulfe/AndroidStudioProjects/pick_flick/lib/utilities/api_errors.dart';
import 'package:pick_flick/utilities/constants.dart';

class Network{

  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try{
      final response = await http.get(BASE_URL + url);
      responseJson = _returnResponse(response);
    } on SocketException{
      throw FetchDataException('No Internet Connection');
    }
    print('api get successful');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response){
    switch(response.statusCode){
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occurred while communicating with server'
            'StatusCode: ${response.statusCode}');
    }
  }
}