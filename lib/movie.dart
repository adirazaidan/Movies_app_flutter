class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;
  
  Movie(this.id, this.title, this.voteAverage, this.releaseDate, this.overview, this.posterPath);

  Movie.fromJson(Map<String, dynamic> parsedJson) {
      id = parsedJson['id'];
      title = parsedJson['title'];
      voteAverage = parsedJson['vote_average']*1.0;
      releaseDate = parsedJson['release_date'];
      overview = parsedJson['overview'];
      posterPath = parsedJson['poster_path'];
  }

}