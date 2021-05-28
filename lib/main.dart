import 'package:flutter/material.dart';
import 'package:hope/visoes/homepage.dart';
import 'package:hope/visoes/lista_doencas.dart';

import 'visoes/lista_perguntas.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PGIA7310",
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        //'quiz': (context) => Quiz(),
        'listaDoencas': (context) => ListaDoencas(),
        'listaPerguntas': (context) => ListaPerguntas(),
      },
    );
  }


}
