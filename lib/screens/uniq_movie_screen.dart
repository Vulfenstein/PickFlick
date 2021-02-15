import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pick_flick/utilities/constants.dart';

class MovieScreen extends StatefulWidget {
  final movie;

  MovieScreen(this.movie);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  PaletteColor colors;

  void initState(){
    super.initState();
  }

  _updateBackground() async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(IMAGEURL+widget.movie['poster_path']),
        size: Size(100,100),
    );
    colors = (generator.dominantColor != null ? generator.darkMutedColor : Colors.black54);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors != null ? colors : Theme.of(context).primaryColor,
        title: Text("Pick Flick"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              child: Image.network(IMAGEURL+widget.movie['poster_path']),
              height: 1200,
              width: 900,
          ),
        ],
      ),
    );
  }
}