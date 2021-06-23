import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/controladores/doenca_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';
import 'package:hope/visoes/tela_cadastro_doenca.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';

class TelaListagemDoencas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemDoencasState();
  }
}

class TelaListagemDoencasState extends State<TelaListagemDoencas> {

  ComponentesUtil _gerenciadorComponentes;
  RepositorioDoenca _repositorioDoencas;
  List<Doenca> _listaDoencas;
  int _totalDoencas;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _repositorioDoencas = RepositorioDoenca();

    if (_listaDoencas == null) {
      _listaDoencas = [];
      _totalDoencas = 0;
      _atualizarListaDoencas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gerenciadorComponentes.appBar("Doenças", context),
      body: _getListaDoencasView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navegarParaCadastroDoenca(Doenca('', '', ''), 'Adicionar doença');
        },
        tooltip: 'Adicionar doença',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListView _getListaDoencasView() {
    return ListView.builder(
      itemCount: _totalDoencas,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(_gerenciadorComponentes.getPrimeirasLetras(this._listaDoencas[position].nome),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this._listaDoencas[position].nome,
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    String mensagem = 'Você tem certeza que deseja apagar a doença?';
                    DialogoConfirmacaoExclusao.showObject(context, mensagem: mensagem, apagar: _apagar,
                        argumento: _listaDoencas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              _navegarParaCadastroDoenca(this._listaDoencas[position], 'Editar doença');
            },
          ),
        );
      },
    );
  }

  void _apagar(Object object) async {
    Doenca doenca = object;
    DoencaController doencaController = DoencaController(doenca);
    int resultado = await doencaController.apagar();

    Navigator.pop(context, true);

    if (resultado != 0) {
      _exibirSnackBar('Doença apagada com sucesso');
      _atualizarListaDoencas();
    } else {
      _exibirSnackBar('Erro ao apagar doença');
    }
  }

  void _exibirSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navegarParaCadastroDoenca(Doenca doenca, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaCadastroDoenca(doenca, titulo);
    }));

    if (result == true) {
      _atualizarListaDoencas();
    }
  }

  void _atualizarListaDoencas() {
    Future<List<Doenca>> listaDoencasFutura = _repositorioDoencas.getListaDoencasAtivas();
    listaDoencasFutura.then((listaDoencas) {
      setState(() {
        this._listaDoencas = listaDoencas;
        this._totalDoencas = listaDoencas.length;
      });
    });
  }

}