import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class swipeScreen extends StatefulWidget {
  @override
  _swipeScreenState createState() => _swipeScreenState();
}

class _swipeScreenState extends State<swipeScreen> with TickerProviderStateMixin{

  List<String> movieposters=[
    "assets/images/blackpanter.jpg",
    "assets/images/dora.jpg",
    "assets/images/harrypotter.webp",
    "assets/images/kingkong.jpg",
  ];

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

              //BLUE
              // Color(0xFFbec4f8),
              // Color(0xFF6a6dde),
              // Color(0xFF6a6dde),
              // Color(0xFF4d42cf),
              // Color(0xFF713d90),

              //RED
              // Color(0xFFaf0704),
              // Color(0xFFb62810),
              // Color(0xFFbc3f09),
              // Color(0xFFc58b0e),

              //lightblue
              Color(0xFF2e4d5e),
              Color(0xFF14575d),
              Color(0xFF36aaa8),

            ],
          ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: new TinderSwapCard(
              swipeUp: true,
              swipeDown: true,
              totalNum: 5,
              stackNum: 2,
              orientation: AmassOrientation.TOP,
              maxWidth: MediaQuery.of(context).size.width*0.9,
              maxHeight: MediaQuery.of(context).size.width*0.9,
              minWidth: MediaQuery.of(context).size.width*0.8,
              minHeight: MediaQuery.of(context).size.width*0.8,

              // Construct new cards
              cardBuilder: (context, index)=>Card(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Image.asset('${movieposters[index]}',
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
