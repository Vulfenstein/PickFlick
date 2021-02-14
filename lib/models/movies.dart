
class Movie {
  final int id;
  final String title;
  final String runtime;
  final String posterUrl;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String metaScore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String website;
  final String production;
  final String boxOffice;

  Movie({this.id, this.title, this.runtime, this.posterUrl, this.director,
      this.writer, this.actors, this.plot, this.language, this.country, this.awards,
      this.metaScore, this.imdbRating, this.imdbVotes, this.imdbID, this.website, this.production, this.boxOffice});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['Title'] as String,
      runtime: json['Runtime'] as String,
      posterUrl: json['Poster'] as String,
      director: json['Director'] as String,
      writer: json['Writer'] as String,
      actors: json['Actors'] as String,
      plot: json['Plot'] as String,
      language: json['language'] as String,
      country: json['Country'] as String,
      awards: json['awards'] as String,
      metaScore: json['Metascore'] as String,
      imdbRating: json['imdbRating'] as String,
      imdbVotes: json['imdbVotes'] as String,
      imdbID: json['imdbID'] as String,
      website: json['Website'] as String,
      production: json['Production'] as String,
      boxOffice: json['BoxOffice'] as String
    );
  }
}