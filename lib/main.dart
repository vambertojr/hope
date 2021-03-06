import 'package:flutter/material.dart';
import 'package:hope/visoes/tela_listagem_doencas_sem_edicao.dart';
import 'package:hope/visoes/tela_perfil_usuario.dart';
import 'package:hope/visoes/tela_inicial.dart';
import 'package:hope/visoes/tela_listagem_doencas.dart';
import 'package:hope/visoes/tela_listagem_perguntas.dart';
import 'package:hope/visoes/tela_listagem_quiz.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PGIA7310",
      initialRoute: 'home',
      routes: {
        'home': (context) => TelaInicial(),
        'quiz': (context) => TelaListagemQuiz(),
        'listaDoencas': (context) => TelaListagemDoencas(),
        'listaDoencasSemEdicao': (context) => TelaListagemDoencasSemEdicao(),
        'listaPerguntas': (context) => TelaListagemPerguntas(),
        'perfilUsuario': (context) => TelaPerfilUsuario()
      },
    );
  }
}


