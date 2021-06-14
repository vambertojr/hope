import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/visoes/homepage.dart';

class MenuEstudante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar
        (title: Text('Hope',),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (
            _buildGridView(context)
        ),
      ),

    );

  }

  void logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
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
  Opcao(titulo: 'Quiz', icon: Icons.article, tela:'quiz'),
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