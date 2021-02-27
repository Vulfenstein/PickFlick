import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:pick_flick/utilities/constants.dart';
import  'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/screens/uniq_movie_screen.dart';
import 'package:pick_flick/models/movie_list_model.dart';
import 'package:pick_flick/bloc/movie_bloc.dart';
import 'file:///C:/Users/vulfe/AndroidStudioProjects/pick_flick/lib/utilities/api_response_status.dart';


class SwipeScreen extends StatefulWidget {

  @override
  SwipeScreenState createState() {
    return new SwipeScreenState();
  }
}


class SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {

  MovieBloc _bloc;

  void initState() {
    super.initState();
    _bloc = MovieBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Pick Flick',),
        ),
        body: Stack(
            children: <Widget>[
              backgroundBuilder(),
              StreamBuilder<ApiResponse<List<Movie>>>(
                stream: _bloc.movieListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Loading();
                      case Status.COMPLETED:
                        return CardBuilder(movies: snapshot.data.data);
                    //return cardBuilder(movieList: snapshot.data.data);
                      case Status.ERROR:
                        return Error(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => _bloc.fetchMovieList(),
                        );
                        break;
                    }
                  }
                  return Container();
                },
              )
            ]
        )

    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(errorMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 24),),
          SizedBox(height: 10,),
          RaisedButton(onPressed: onRetryPressed, color: Colors.blue,),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
// ----------------------------------------------------------------------------//
//  Constructs cards for swiping
// ----------------------------------------------------------------------------//

class CardBuilder extends StatelessWidget {
  final List<Movie> movies;

  const CardBuilder({Key key, this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: new TinderSwapCard(
              totalNum: movies != null ? movies.length : 0,
              stackNum: 3,
              orientation: AmassOrientation.TOP,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 2,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,

              // Construct new cards
              cardBuilder: (context, index) =>
                  FlatButton(
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
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new MovieScreen(movies[index].id);
                          },),),
                  ),

              //Get orientation and index of swiped card
              swipeCompleteCallback: (CardSwipeOrientation orientation,
                  int index) {
                var currentIndex = index;
                print("$currentIndex ${orientation.toString()}");
                if (orientation == CardSwipeOrientation.RIGHT) {
                  print('hello');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}





