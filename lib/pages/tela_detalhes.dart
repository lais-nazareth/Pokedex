import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/arguments.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Detalhes extends StatefulWidget {
    static String routeName = '/pokemon-detail';

  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  @override
  Widget build(BuildContext context) {
    final PokemonArguments args = ModalRoute.of(context)!.settings.arguments as PokemonArguments;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey,
              child: Center(
                child: _buildImage(args.pokemonImageUrl)
              ),
            )
          ],

        ),
      )
    );
  }
}

Widget _buildImage(String? imageUrl){
  if (imageUrl == null || imageUrl.isEmpty){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.help_outline, size:100, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No image available',
          style: TextStyle(color: Colors.grey),
          )
      ],
    );
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.contain,
    loadingBuilder: (context, child, loadingProgress){
      if (loadingProgress == null) return child;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
          SizedBox(height: 16,),
          Text('Carregando'),
        ],
      );
    },
    errorBuilder: (context, error, stackTrace){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 100, color: Colors.red,),
          SizedBox(height: 16,),
          Text(
            'Falha ao carregar Imagem',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 8,),
          Text(
              'URL: ${imageUrl.length > 50 ? '${imageUrl.substring(0, 50)}...' : imageUrl}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
        ],
      );
    },
  );
}

