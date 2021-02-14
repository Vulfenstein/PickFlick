import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:pick_flick/models/movies.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/utilities/widgets.dart';

class SwipeScreen extends StatefulWidget {

  SwipeScreen({this.movieInfo});
  final movieInfo;

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Flick"),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              //lightblue
              Color(BACKGROUND_COLOR_1),
              Color(BACKGROUND_COLOR_2),
              Color(BACKGROUND_COLOR_3),
            ],
          ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: new TinderSwapCard(
              totalNum: 10,
              stackNum: 3,
              orientation: AmassOrientation.TOP,
              maxWidth: MediaQuery.of(context).size.width*0.9,
              maxHeight: MediaQuery.of(context).size.width*5,
              minWidth: MediaQuery.of(context).size.width*0.8,
              minHeight: MediaQuery.of(context).size.width*0.8,

              // Construct new cards
              cardBuilder: (context, index)=>Card(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Image.network('${widget.movieInfo['Poster']}',
                    fit: BoxFit.fill,
                  ),
                ),
                elevation: 20.0,
              ),

              //Track swipe direction
              // cardController: CardController(),
              // swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
              //   if (align.x < 0){
              //     print("swipped left");
              //   }
              //   else if(align.x > 0){
              //     print("swipped right");
              //   }
              // },

              //Get orientation and index of swipped card
              swipeCompleteCallback: (CardSwipeOrientation orientation, int index){
                var currentIndex = index;
                print("$currentIndex ${orientation.toString()}");
              },
            ),
          ),
        ),
      ),
    );
  }
}
