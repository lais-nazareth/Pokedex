import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/arguments.dart';
import 'package:pokedex_app/pages/home.dart';
import 'package:pokedex_app/pages/tela_lista.dart';

class Geracao extends StatefulWidget {
  static String routeName = '/geracao';

  const Geracao({super.key});

  @override
  State<Geracao> createState() => _GeracaoState();
}

class _GeracaoState extends State<Geracao> {
  String? _geracao;
  String? url = 'generation/';

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
          'Geração',
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
              value: _geracao,
              items: const [
                DropdownMenuItem(value:'1/', child: Text('1')),
                DropdownMenuItem(value:'2/', child: Text('2')),
                DropdownMenuItem(value:'3/', child: Text('3')),
                DropdownMenuItem(value:'4/', child: Text('4')),
                DropdownMenuItem(value:'5/', child: Text('5')),
                DropdownMenuItem(value:'6/', child: Text('6')),
                DropdownMenuItem(value:'7/', child: Text('7')),
                DropdownMenuItem(value:'8/', child: Text('8')),
                DropdownMenuItem(value:'9/', child: Text('9')),
                
              ], 
              onChanged: (String? selectedOption){
                if(selectedOption is String){
                  setState(() {
                    _geracao = selectedOption;
                  });
                }
              },
              hint: Text(
                'Geração'
              ),
              ),
            ElevatedButton(
              onPressed: (_geracao != null) ? () {
                Navigator.pushNamed(
                  context, 
                  Lista.routeName,
                  arguments: Arguments(
                    'Lista',
                    url! + _geracao!
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
                'Selecionar Geração',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            )
          ],
        ),
      ),
    );
  }
}