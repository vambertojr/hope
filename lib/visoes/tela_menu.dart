import 'package:flutter/material.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';

class TelaMenu extends StatelessWidget {

  @override
  Widget build(BuildContext contexto) {
    GerenciadorComponentes gerenciadorComponentes = GerenciadorComponentes();

    return Scaffold(
      appBar: AppBar
        (title: Text('Hope',),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              gerenciadorComponentes.logout(contexto);
            },
            icon: Icon(Icons.logout),
          )
        ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (
            _configurarGridView(contexto)
        ),
      ),

    );

  }

  GridView _configurarGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(opcoes.length, (index) {
        return Center(
          child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(opcoes[index].tela);
              },
              child: OpcaoCard(opcao: opcoes[index])),
        );
      }),
    );
  }

}

class Opcao {
  Opcao({this.titulo, this.icon, this.tela});
  String titulo;
  IconData icon;
  String tela;
}

List<Opcao> opcoes = <Opcao>[
  Opcao(titulo: 'Início', icon: (Icons.home ), tela:'home'),
  Opcao(titulo: 'Perfil', icon: Icons.account_box, tela:'perfilUsuario'),
  Opcao(titulo: 'Doenças', icon: Icons.sick, tela:'listaDoencas'),
  Opcao(titulo: 'Perguntas', icon: Icons.question_answer, tela:'listaPerguntas'),
];

class OpcaoCard extends StatelessWidget {
  const OpcaoCard({Key key, this.opcao}) : super(key: key);
  final Opcao opcao;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context)
        .textTheme.headline4;
    return Card(
        color: Colors.white,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(opcao.icon, size:60.0, color: textStyle.color),
                Text(opcao.titulo, style: textStyle),
              ]
          ),
        )
    );
  }
}