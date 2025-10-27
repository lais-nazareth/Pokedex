class Arguments {
  String title;
  String message;

  Arguments(this.title, this.message);
}


class PokemonArguments {
  final String pokemonName;
  final String? pokemonImageUrl;
  final String pokemonUrl;

  PokemonArguments({required this.pokemonName, this.pokemonImageUrl, required this.pokemonUrl});
}