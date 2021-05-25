import 'package:flutter/material.dart';
import 'package:hope/screens/homepage.dart';
import 'package:hope/screens/lista_doencas.dart';

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
        'ListaDoencas': (context) => ListaDoencas(),
        //'screen2': (context) => screen2(),

      },
    );
  }


}
