import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/helper_functions.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pick_flick/utilities/error_messages.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  var detail;
  String newVal;
  int _currentIndex = 0;
  TextEditingController _controller;
  Icon searchIcon = new Icon(Icons.search);
  Widget pageTitle = new Text("Pick Flick");
  List <String> categories = ["Friends", "Log Out"];

  void changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  Future getData(String title) async {
    var data = await getJson(title);
    detail = data;
    return detail;
  }

  // ignore: missing_return
  Future<Map> getJson(String title) async {
    try {
      var url =
          MOVIE_SEARCH + API_KEY + '&query=' + title;
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  void searchHandle(String value) async{
    String result = value.replaceAll(' ', '+');
    final movie = await getData(result);
    if(movie['results'].isNotEmpty){
      Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MovieScreen(movie['results'][0]['id']);
        },),);
    }
    else{
      movieNotFound(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Color(0xFF14575d),
          title: pageTitle,
          leading: IconButton(icon: searchIcon, onPressed:(){
            setState(() {
              if(searchIcon.icon == Icons.search){
                searchIcon = new Icon(Icons.close);
                pageTitle = new TextField(
                  controller: _controller,
                  onSubmitted: (String value) async {
                    searchHandle(value);
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Search for movie',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                );
              }
              else{
                searchIcon = new Icon(Icons.search);
                pageTitle = new Text("Pick Flick");
              }
            });
          },),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 10)),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                items: categories.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),);
                }).toList(),
                onChanged: (String input){
                    topBarSelection(input, context);
                },
                icon: new Icon(Icons.dehaze, color: Colors.white,),
                dropdownColor: Color(0xFF36aaa8),),
            ),
            Padding(padding: EdgeInsets.only(right: 15)),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
            onTap: changeScreen,
            fixedColor: Colors.white,
            backgroundColor: Color(0xFF2e4d5e),
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: new Icon(Icons.lightbulb), label: "Matches"),
              BottomNavigationBarItem(icon: new Icon(Icons.chat), label: "Chat"),
            ]),

        body: IndexedStack(
          children: <Widget>[
            MovieSwipe(),
            MatchScreen(),
            ChatScreen(),
          ],
          index: _currentIndex,
        ),
    );
  }
}

