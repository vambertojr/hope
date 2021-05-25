import 'package:flutter/material.dart';

class menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar
        (title: Text('Hope',),
        backgroundColor: Colors.teal
        ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (
            _buildGridView(context)
        ),
      ),

    );

  }

  GridView _buildGridView(BuildContext context) {
    return GridView.count(
      //cria um grid com 2 colunas
      crossAxisCount: 2,
      // Gera 100 Widgets que exibem o seu índice na lista
      children: List.generate(opcoes.length, (index) {
        return Center(
          child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(opcoes[index].caminho1);
                Navigator.of(context).pushNamed(opcoes[index].caminho2);
                Navigator.of(context).pushNamed(opcoes[index].caminho3);
              },
              child: OpcaoCard(opcao: opcoes[index])),


        );
      }),
    );
  }


}

class Opcao {
  Opcao({this.titulo, this.icon, this.caminho1, this.caminho2, this.caminho3});
  String titulo;
  IconData icon;
  String caminho1;
  String caminho2;
  String caminho3;

}
List<Opcao> opcoes = <Opcao>[
  Opcao(titulo: 'Início', icon: (Icons.home )  ),
  Opcao(titulo: 'Quiz', icon: Icons.contact_support, caminho1: "screen3"),
  Opcao(titulo: 'Doenças', icon: Icons.directions_boat, caminho2: "ListaDoencas"),
  Opcao(titulo: 'Ônibux', icon: Icons.directions_bus),

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