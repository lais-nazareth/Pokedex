import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/pages/arguments.dart';
import 'package:pokedex_app/pages/home.dart';
import 'dart:convert';

class PokemonItem {
  String nome;
  String? imageUrl;
  String detailUrl;

  PokemonItem({required this.nome, this.imageUrl, required this.detailUrl});
} 

class Lista extends StatefulWidget {
  static String routeName = '/lista';

  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  late String endpoint;
  Future<List<PokemonItem>>? listaPokemonsFuture;

  Future<String?> buscarPokemon(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);


        final sprites = data['sprites'];
        
        final officialArtwork = sprites['other']['official-artwork']?['front_default'];
        if (officialArtwork != null) {
          return officialArtwork;
        }

        final dreamWorld = sprites['other']['dream_world']?['front_default'];
        if (dreamWorld != null) {
          return dreamWorld;
        }

        final homeArtwork = sprites['other']['home']?['front_default'];
        if (homeArtwork != null) {
          return homeArtwork;
        }

        final defaultSprite = sprites['front_default'];
        if (defaultSprite != null) {
          return defaultSprite;
        }

        print('No sprite found for ${data['name']}');
        return null;
      } else {
        print('HTTP error ${response.statusCode} for URL: $url');
        return null;
      }
    } catch (e) {
      print('Error fetching Pokemon: $e');
      return null;
    }
  }

  Future<List<PokemonItem>> getPokemons(String endpoint) async {
    try {
      String url = 'https://pokeapi.co/api/v2/$endpoint';
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Falha ao carregar: ${response.statusCode}');
      }

      Map<String, dynamic> reqData = jsonDecode(response.body);
      

      List<dynamic> speciesList;
      if (reqData.containsKey('pokemon_species')) {
        speciesList = reqData['pokemon_species'];
      } else if (reqData.containsKey('pokemon')) {
        speciesList = reqData['pokemon'];
      } else {
        speciesList = reqData['results'] ?? [];
      }

      List<PokemonItem> tempLista = [];
      List<String> detailUrls = [];

      for (var speciesData in speciesList) {
        Map<String, dynamic>? pokemonEntry;

        if (speciesData.containsKey('pokemon')) {
          pokemonEntry = speciesData['pokemon'];
        } else if (speciesData.containsKey('species')) {
          pokemonEntry = speciesData;
          final speciesUrl = pokemonEntry?['url'] ?? '';
          if (speciesUrl.isNotEmpty) {
            final pokemonId = speciesUrl.split('/').where((e) => e.isNotEmpty).last;
            pokemonEntry = {'url': 'https://pokeapi.co/api/v2/pokemon/$pokemonId/'};
          }
        } else {
          pokemonEntry = speciesData;
        }

        final String name = pokemonEntry?['name'] ?? '???';
        String detailUrl = pokemonEntry?['url'] ?? '';

        if (detailUrl.contains('/pokemon-species/')) {
          final speciesId = detailUrl.split('/').where((e) => e.isNotEmpty).last;
          detailUrl = 'https://pokeapi.co/api/v2/pokemon/$speciesId/';
        }

        tempLista.add(PokemonItem(nome: name, imageUrl: null, detailUrl: detailUrl));

        if (detailUrl.isNotEmpty && detailUrl.contains('/pokemon/')) {
          detailUrls.add(detailUrl);
        } else {
          detailUrls.add('');
          print('Invalid URL for $name: $detailUrl');
        }
      }


      final List<Future<String?>> spritesFuture = detailUrls.map((url) async {
        if (url.isEmpty) return null;
        return await buscarPokemon(url);
      }).toList();

      final List<String?> spriteUrls = await Future.wait(spritesFuture);


      for (int i = 0; i < tempLista.length; i++) {
        tempLista[i].imageUrl = spriteUrls[i];
      }

      return tempLista;
    } catch (e) {
      print('Error in getPokemons: $e');
      rethrow;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Arguments args = ModalRoute.of(context)!.settings.arguments as Arguments;
    endpoint = args.message;

    if (listaPokemonsFuture == null) {
      listaPokemonsFuture = getPokemons(endpoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context)!.settings.arguments as Arguments;
    final String title = args.title;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['blue'],
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'images/pokeball.png',
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: Center(
        child: FutureBuilder(
          future: listaPokemonsFuture, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando Pokémon...'),
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Erro ao carregar dados: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final pokemonList = snapshot.data!;

              if (pokemonList.isEmpty) {
                return Text('Nenhum pokémon encontrado');
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(8),
                itemCount: pokemonList.length, 
                itemBuilder: (context, index) {
                  final pokemon = pokemonList[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                        context, 
                        '/pokemon-detail',
                        arguments: PokemonArguments(pokemonName: pokemon.nome, pokemonImageUrl: pokemon.imageUrl, pokemonUrl: pokemon.detailUrl)
                      );
                    },
                    child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: (pokemon.imageUrl != null) 
                              ? Image.network(
                                  pokemon.imageUrl!,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text(
                                          'Imagem\nnão carregada',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.help_outline, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'Sem\nimagem',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            pokemon.nome.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  );
                },
              );
            }
            return Text('Buscando...');
          },
        ),
      ),
    );
  }
}