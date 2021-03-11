// Swipe stack
import 'package:flutter/material.dart';
import 'package:pick_flick/bloc/movie_bloc.dart';
import 'package:pick_flick/models/movie_list.dart';
import 'package:pick_flick/utilities/api_helper_functions.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:pick_flick/utilities/screen_export.dart';
import 'package:pick_flick/utilities/constants.dart';


class MovieSwipe extends StatefulWidget {
  @override
  _MovieSwipeState createState() => _MovieSwipeState();
}

class _MovieSwipeState extends State<MovieSwipe> {
  MovieBloc _bloc;
  String newVal = "Popular";
  int genreId = 0;
  List <String> categories = [
    "Popular","Action", "Comedy","Drama", "Fantasy",
    "Horror", "Mystery", "Romance", "Thriller"
  ];

  void initState() {
    _bloc = MovieBloc();
    super.initState();
  }

  void dispose(){
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          BackgroundBuilder(),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black, fontSize: 20,),)
                  );
              }).toList(),
              onChanged: (String changed){
                newVal = changed;
                genreId = getVal(newVal);
                setState(() {
                  if(genreId == 0){
                    _bloc.fetchMovieList();
                  }else {
                    _bloc.fetchGenreList(genreId);
                  }
                });
              },
              hint: Text(
                newVal,
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500,)),
              dropdownColor: Color(0xFF36aaa8),),
          ),

          StreamBuilder<ApiResponse<List<Movie>>>(
            stream: _bloc.movieListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Loading();
                  case Status.COMPLETED:
                    return CardBuilder(movies: snapshot.data.data, bloc: _bloc, genreID: genreId);
                  case Status.ERROR:
                    print(snapshot.data.message);
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _bloc.fetchMovieList(),
                    );
                    break;
                }
              }
              return Container();
            },

          ),
        ]
    );
  }
}

//  Swipe card constructor
class CardBuilder extends StatelessWidget {
  final List<Movie> movies;
  final MovieBloc bloc;
  final int genreID;

  const CardBuilder({Key key, this.movies, this.bloc, this.genreID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 60),
            height: MediaQuery.of(context).size.height * 0.9,
            child: new TinderSwapCard(
              totalNum: movies != null ? movies.length : 0,
              stackNum: 3,
              orientation: AmassOrientation.TOP,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 1.2,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 1,

              // Construct new cards
              cardBuilder: (context, index) =>
                  GestureDetector(
                    child: Card(
                      elevation: 100.0,
                      child: Padding(
                        padding: EdgeInsets.all(1.5),
                        child: Image.network(
                          IMAGEURL + movies[index].posterPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new MovieScreen(movies[index].id);
                          },),),
                  ),

              //Get orientation and index of swiped card
              swipeCompleteCallback: (CardSwipeOrientation orientation,
                  int index) {
                var currentIndex = index;
                if(currentIndex >= 19){
                  if(genreID == 0){
                    bloc.fetchNextPage();
                  }else{
                    bloc.fetchGenreNextPage();
                  }
                }
                print("$currentIndex ${orientation.toString()}");
                if (orientation == CardSwipeOrientation.RIGHT) {
                  addMovies(movies[index]);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
