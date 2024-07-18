import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'http_helper.dart';
import 'movie_detail.dart';
import 'widgetShimmer.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late String result;
  late HttpHelper helper;
  int moviesCount = 0;
  List movies = [];
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Movies');
  bool isLoading = true;

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(title: searchBar, actions: <Widget>[
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(() {
              if (visibleIcon.icon == Icons.search) {
                visibleIcon = const Icon(Icons.cancel);
                searchBar = TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (String text) {
                    search(text);
                  },
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                  ),
                );
              } else {
                setState(() {
                  visibleIcon = const Icon(Icons.search);
                  searchBar = const Text('Movies');
                });
              }
            });
          },
        ),
      ]),
      body: isLoading
          ? const widgetShimmer()
          : RefreshIndicator(
              onRefresh: _refreshMovies,
              child: ListView.builder(
                  itemCount: moviesCount,
                  itemBuilder: (BuildContext context, int position) {
                    if (movies[position].posterPath != null) {
                      image = NetworkImage(iconBase + movies[position].posterPath);
                    } else {
                      image = NetworkImage(defaultImage);
                    }
                    return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (_) => MovieDetail(movies[position]));
                            Navigator.push(context, route);
                          },
                          leading: CircleAvatar(
                            backgroundImage: image,
                          ),
                          title: Text(movies[position].title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Released: ${movies[position].releaseDate}'),
                              //Rating dengan star rating
                              RatingStars(
                                value: movies[position].voteAverage / 2, 
                                starBuilder: (index, color) => Icon(
                                  Icons.star,
                                  color: color,
                                  size: 16.0,
                                ),
                                starCount: 5,
                                starSize: 16.0,
                                maxValue: 5,
                                starSpacing: 1.0,
                                maxValueVisibility: false,
                                valueLabelVisibility: false,
                                animationDuration: Duration(milliseconds: 1000),
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
    );
  }

  // Method refreshMovies
  Future<void> _refreshMovies() async {
    await initialize();
  }

  Future search(String text) async {
    setState(() {
      isLoading = true;
    });
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      isLoading = false;
    });
  }

  Future initialize() async {
    setState(() {
      isLoading = true;
    });
    movies = [];
    movies = (await helper.getUpcoming())!;
    setState(() {
      moviesCount = movies.length;
      isLoading = false;
    });
  }
}
