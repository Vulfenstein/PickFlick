import 'package:flutter/material.dart';
import 'package:pick_flick/screens/match_screen.dart';
import 'package:pick_flick/screens/password_screen.dart';
import 'package:pick_flick/bloc/movie_bloc.dart';
import 'package:pick_flick/screens/swipe_screen.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  int _currentIndex = 0;
  List <String> categories = ["Action", "Comedy","Drama", "Fantasy", "Horror", "Mystery", "Romance", "Thriller"];

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
          leading: DropdownButton(),
          backgroundColor: Color(0xFF14575d),
          title: Text('Pick Flick',),
          actions: <Widget>[
            DropdownButton(
              items: categories.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),);
            }).toList(),
              onChanged: (_){},
              icon: new Icon(Icons.dehaze, color: Colors.white,),
              dropdownColor: Color(0xFF36aaa8),),
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
            PasswordScreen(),
          ],
          index: _currentIndex,
        ),
    );
  }
}

