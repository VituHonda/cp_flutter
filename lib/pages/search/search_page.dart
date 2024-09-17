import 'package:cp_flutter/models/movie_model.dart';
import 'package:cp_flutter/pages/search/widgets/movie_search.dart';
import 'package:cp_flutter/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  late Future<Result> result;
  late Future<List<Map<String, dynamic>>> genreFuture;
  late String selectedType;
  int? selectedGenreId;

  @override
  void initState() {
    result =
        apiServices.getPopularMovies();
    genreFuture =
        apiServices.getMovieGenres();
    super.initState();
  }

  void search(String query) {
    setState(() {
      if (query.isEmpty) {
        result = apiServices.getPopularMovies();
      } else if (query.length > 4) {
        result = apiServices.getSearchedMovie(query);
      }
    });
  }

  void searchByGenre(int genreId) {
    setState(() {
      result = apiServices
          .getMoviesByGenre(genreId);
    });
  }

  void showTypesDialog(List<Map<String, dynamic>> genres) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Genre"),
          content: SizedBox(
            height: 300.0,
            width: double.maxFinite,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(genres[index]['name']),
                    onTap: () {
                      int genreId = genres[index]['id']; 
                      setState(() {
                        selectedType = genres[index]
                            ['name'];
                        selectedGenreId = genreId;
                        searchByGenre(
                            genreId);
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchTitle = searchController.text.isEmpty
        ? 'Top Searches'
        : 'Search Result for ${searchController.text}';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CupertinoSearchTextField(
                  controller: searchController,
                  padding: const EdgeInsets.all(10.0),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  onChanged: (value) {
                    search(searchController.text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchTitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {

                        genreFuture.then((genres) {
                          showTypesDialog(genres);
                        });
                      },
                      child: const Text("Search By Genre"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<Result>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data?.movies;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (data![index].backdropPath.isEmpty) {
                          return const SizedBox();
                        }
                        return MovieSearch(movie: data[index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
