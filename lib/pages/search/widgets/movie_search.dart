import 'package:flutter/material.dart';
import 'package:cp_flutter/common/utils.dart';
import 'package:cp_flutter/models/movie_model.dart';
import 'package:cp_flutter/pages/movie_detail/movie_detail_page.dart';

class MovieSearch extends StatelessWidget {
  final Movie movie;

  const MovieSearch({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Image.network(
              '$imageUrl${movie.posterPath}',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
