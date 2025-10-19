import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/arguments.dart';
import 'package:pokedex_app/pages/home.dart';
import 'package:pokedex_app/pages/tela_lista.dart';

class Habitat extends StatefulWidget {
  static String routeName = '/habitat';

  const Habitat({super.key});

  @override
  State<Habitat> createState() => _HabitatState();
}

class _HabitatState extends State<Habitat> {
  String? _habitat;
  String? url = 'pokemon-habitat/';

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
          'Habitat',
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
            DropdownButton(
              value: _habitat,
              items: const [
                DropdownMenuItem(value:'1/', child: Text('Cave')),
                DropdownMenuItem(value:'2/', child: Text('Forest')),
                DropdownMenuItem(value:'3/', child: Text('Grassland')),
                DropdownMenuItem(value:'4/', child: Text('Mountain')),
                DropdownMenuItem(value:'5/', child: Text('Rare')),
                DropdownMenuItem(value:'6/', child: Text('Rough Terrain')),
                DropdownMenuItem(value:'7/', child: Text('Sea')),
                DropdownMenuItem(value:'8/', child: Text('Urban')),
                DropdownMenuItem(value:'9/', child: Text('Waters-edge')),
                
              ], 
              onChanged: (String? selectedOption){
                if(selectedOption is String){
                  setState(() {
                    _habitat = selectedOption;
                  });
                }
              },
              hint: Text(
                'Habitat'
              ),
              ),
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