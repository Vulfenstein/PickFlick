import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/helper_functions.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  int _currentIndex = 0;
  List <String> categories = ["Friends","Settings", "Log Out"];
  String newVal;
  Icon searchIcon = new Icon(Icons.search);
  Widget pageTitle = new Text("Pick Flick");

  void changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                    topBarSelection(input);
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

