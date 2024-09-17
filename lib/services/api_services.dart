import 'dart:convert';

import 'package:cp_flutter/models/favorite_request.dart';
import 'package:cp_flutter/models/favorite_response.dart';
import 'package:http/http.dart' as http;
import 'package:cp_flutter/common/utils.dart';
import 'package:cp_flutter/models/movie_detail_model.dart';
import 'package:cp_flutter/models/movie_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
const key = '?api_key=$apiKey';

class ApiServices {
  // HOME
  Future<Result> getPopularMovies() async {
    const endPoint = 'movie/popular';
    const url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Result> getNowPlayingMovies() async {
    var endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Result> getUpcomingMovies() async {
    var endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  // FAVORITES

  Future<Result> getFavoriteMovies() async {
    var endPoint =
        'https://api.themoviedb.org/3/account/21512588/favorite/movies?language=en-US&page=1&sort_by=created_at.asc';

    final response = await http.get(
      Uri.parse(endPoint),
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNmFiYWZhNGY2MzAwMGU1NmZiNGUzYmY0YmIzZWViZiIsIm5iZiI6MTcyNjUyMjk1OC4zNjkzMTcsInN1YiI6IjY2ZTBjOTJlZjA0MGU4MzY4OTM1YTI1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BrD5ckSHiZMQu5yu9kp8DdNvSlPK1Ua8QapWW9cZYn8"
      },
    );

    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<FavoriteResponse> postFavoriteStatus(
      int mediaId, bool isFavorite) async {
    var endPoint = 'https://api.themoviedb.org/3/account/21512588/favorite';

    final request = FavoriteRequest(
      mediaType: "movie",
      mediaId: mediaId,
      favorite: isFavorite,
    );

    final response = await http.post(
      Uri.parse(endPoint),
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNmFiYWZhNGY2MzAwMGU1NmZiNGUzYmY0YmIzZWViZiIsIm5iZiI6MTcyNjUyMjk1OC4zNjkzMTcsInN1YiI6IjY2ZTBjOTJlZjA0MGU4MzY4OTM1YTI1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BrD5ckSHiZMQu5yu9kp8DdNvSlPK1Ua8QapWW9cZYn8"
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return FavoriteResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Falha ao favoritar/desfavoritar: ${response.statusCode}');
    }
  }

  // SEARCH

  Future<Result> getSearchedMovie(String searchText) async {
    final endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NTAyYjhjMDMxYzc5NzkwZmU1YzBiNGY5NGZkNzcwZCIsInN1YiI6IjYzMmMxYjAyYmE0ODAyMDA4MTcyNjM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N1SoB26LWgsA33c-5X0DT5haVOD4CfWfRhwpDu9eGkc'
    });
    if (response.statusCode == 200) {
      final movies = Result.fromJson(jsonDecode(response.body));
      return movies;
    }
    throw Exception('failed to load  search movie ');
  }

  // TOP RATED

  Future<Result> getTopRatedMovies() async {
    var endPoint = 'movie/top_rated';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  // Details

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<Result> getMovieRecommendations(int movieId) async {
    final endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }
}
