import 'package:cp_flutter/models/movie_model.dart';
import 'package:cp_flutter/pages/top_rated/widgets/top_rated_movie.dart';
import 'package:cp_flutter/services/api_services.dart';
import 'package:flutter/material.dart';

class TopRatedPage extends StatefulWidget {
  const TopRatedPage({super.key});

  @override
  State<TopRatedPage> createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  ApiServices apiServices = ApiServices();
  late Future<Result> topRatedMoviesFuture;

  @override
  void initState() {
    topRatedMoviesFuture = apiServices.getTopRatedMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Hated Movies'),
      ),
      body: FutureBuilder<Result>(
        future: topRatedMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.movies.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data!.movies[index];
                return TopHatedMovie(movie: movie);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
