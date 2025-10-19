import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/home.dart';

class NomeId extends StatefulWidget {
  static String routeName = '/id';

  const NomeId({super.key});

  @override
  State<NomeId> createState() => _NomeIdState();
}

class _NomeIdState extends State<NomeId> {
  TextEditingController _controller = TextEditingController();
  String? url = 'pokemon/';

  @override
  Widget build(BuildContext context) {
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
          'Nome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _controller,
            )
            
            ElevatedButton(
              onPressed: (_habitat != null) ? () {
                Navigator.pushNamed(
                  context, 
                  Lista.routeName,
                  arguments: Arguments(
                    'Lista',
                    url! + _habitat!
                  ));
              } : null,

              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.blueGrey,
                disabledForegroundColor: Colors.white,
                backgroundColor: colors['blue'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                foregroundColor: Colors.white

              ),
              child: Text(
                'Selecionar Habitat',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            )
          ],
        ),
      ),
    );
  }
}