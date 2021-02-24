import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pick_flick/utilities/utilities_export.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class MovieScreen extends StatefulWidget {

  int movieId;
  MovieScreen(this.movieId);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  PaletteColor colors;
  var detail;

  void initState() {
    super.initState();
  }

// ----------------------------------------------------------------------------//
//  Get detailed movie data
// ----------------------------------------------------------------------------//
  Future getData() async {
    var data = await getJson();
    detail = data;
    return detail;
  }


  // ignore: missing_return
  Future<Map> getJson() async {
    try {
      var url = MOVIE_URL + widget.movieId.toString()+API_ATTACHMENT+TMDB_V3;
      var response = await http.get(url);
      return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

// ----------------------------------------------------------------------------//
//  Background color gradient
// ----------------------------------------------------------------------------//
  _backgroundBuilder(){
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(BACKGROUND_COLOR_1),
            Color(BACKGROUND_COLOR_2),
            Color(BACKGROUND_COLOR_3),
          ],
        ));
  }

// ----------------------------------------------------------------------------//
//  Build title text
// ----------------------------------------------------------------------------//
  _titleBuilder(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        detail['title'],
        style: TextStyle(
            color: Colors.black, fontSize: 25.0),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Builds rating row
// ----------------------------------------------------------------------------//
  _ratingBuilder(){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: StarRating(
            rating: detail['vote_average'],
            starConfig: StarConfig(
              size: 16.0,
              strokeColor: Colors.black54,
              fillColor: Colors.black54,
              emptyColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 13.0,),
        Text(detail['vote_average'].toString()+'k reviews'),
      ],
    );
  }

// ----------------------------------------------------------------------------//
//  Builds release date row
// ----------------------------------------------------------------------------//
  _releaseDateBuilder(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.black54,
            size: 17.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            detail['release_date'],
            style: TextStyle(
                color: Colors.black54, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Builds runtime row
// ----------------------------------------------------------------------------//
  _runtimeBuilder(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: Colors.black54,
            size: 17.0,
          ),
          SizedBox(width: 10.0,),
          Text(durationToString(detail['runtime']),
            style: TextStyle(
                color: Colors.black54, fontSize: 14.0
            ),),
        ],
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Movie description
// ----------------------------------------------------------------------------//
  _overviewBuilder(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        detail['overview'],
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

// ----------------------------------------------------------------------------//
//  Convert total minutes to hours and minutes.
// ----------------------------------------------------------------------------//
  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
  }

// ----------------------------------------------------------------------------//
//  Build Context
// ----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getData(),
    builder: (context, snapshot) {
    if(snapshot.hasData) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Scaffold(
              // backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                ),
                backgroundColor: Colors.transparent,
                //elevation: 0.0,
              ),
            ),
            Container(
              decoration: _backgroundBuilder(),
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 735.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        IMAGEURL + detail['poster_path'],
                        height: 450.0,
                        width: 400.0,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20.0,),
                      _titleBuilder(),
                      SizedBox(height: 7.0,),
                      _ratingBuilder(),
                      SizedBox(height: 10.0,),
                      _runtimeBuilder(),
                      SizedBox(height: 10.0,),
                      _releaseDateBuilder(),
                      SizedBox(height: 15.0,),
                      _overviewBuilder(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Center(child: CircularProgressIndicator());
    }
  });
}
