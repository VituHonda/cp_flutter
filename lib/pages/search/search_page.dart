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
  late Future<List<Map<String, dynamic>>> genreFuture; // Lista com ID e nome
  late String selectedType;
  int? selectedGenreId; // Variável para armazenar o ID do gênero selecionado

  @override
  void initState() {
    result =
        apiServices.getPopularMovies(); // Busca inicial de filmes populares
    genreFuture =
        apiServices.getMovieGenres(); // Inicializa a busca dos gêneros
    super.initState();
  }

  // Função para buscar filmes pelo termo inserido
  void search(String query) {
    setState(() {
      if (query.isEmpty) {
        // Se a busca estiver vazia, exibe os filmes populares
        result = apiServices.getPopularMovies();
      } else if (query.length > 4) {
        // Se a busca tiver mais de 4 caracteres, realiza a busca do termo
        result = apiServices.getSearchedMovie(query);
      }
    });
  }

  // Função chamada ao selecionar um gênero, carrega os filmes daquele gênero
  void searchByGenre(int genreId) {
    setState(() {
      result = apiServices
          .getMoviesByGenre(genreId); // Chama a função passando o ID do gênero
    });
  }

  // Função para exibir o diálogo de seleção de gênero
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
                        Text(genres[index]['name']), // Exibe o nome do gênero
                    onTap: () {
                      int genreId = genres[index]['id']; // Pega o ID do gênero
                      setState(() {
                        selectedType = genres[index]
                            ['name']; // Atualiza o tipo selecionado
                        selectedGenreId = genreId; // Armazena o ID do gênero
                        searchByGenre(
                            genreId); // Busca filmes com base no gênero selecionado
                      });
                      Navigator.of(context).pop(); // Fecha o diálogo
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
                    search(searchController.text); // Chama a função de busca
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
                        // Exibe a lista de gêneros no diálogo
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
              // Exibe a lista de filmes com base no Future result
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
