import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';

class DoencaInfo extends StatefulWidget {

  final String appBarTitle;
  final Doenca doenca;

  DoencaInfo(this.doenca, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return DoencaInfoState(this.doenca, this.appBarTitle);
  }
}

class DoencaInfoState extends State<DoencaInfo> {

  DoencaRepositorio helper = DoencaRepositorio();

  String appBarTitle;
  Doenca doenca;

  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  String agenteController;


  DoencaInfoState(this.doenca, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    nomeController.text = doenca.nome;
    descricaoController.text = doenca.descricao;
    agenteController = doenca.agenteEtiologico?.isEmpty ? 'Vírus' : doenca.agenteEtiologico;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nomeController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Name Text Field');
                      atualizarNome();
                    },
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descricaoController,
                    style: textStyle,
                    minLines: 10,
                    maxLines: 20,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      atualizarDescricao();
                    },
                    decoration: InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    value: agenteController,
                    onChanged: (value) {
                      debugPrint('Something changed in Agente Field');
                      agenteController = value;
                      atualizarAgente();
                    },
                    decoration: InputDecoration(
                        labelText: 'Agente etiológico',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: <String>['Vírus', 'Bactéria', 'Fungo', 'Protozoário', 'Outros']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,

                          textColor: Theme.of(context).primaryColorLight,

                          child: Text(
                            'Salvar',
                            textScaleFactor: 1.5,

                          ),
                          onPressed: () {
                              setState(() {
                              debugPrint("Save button clicked");

                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Deletar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void atualizarNome(){
    doenca.nome = nomeController.text;
  }

  void atualizarDescricao() {
    doenca.descricao = descricaoController.text;
  }

  void atualizarAgente(){
    doenca.agenteEtiologico = agenteController;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    int result;
    if (doenca.id != null) {  // Case 1: Update operation
      result = await helper.atualizarDoenca(doenca);
    } else { // Case 2: Insert Operation
      result = await helper.inserirDoenca(doenca);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Doença salva com sucesso');
    } else {  // Failure
      _showAlertDialog('Status', 'Erro ao salvar doença');
    }

  }


  void _delete() async {

    moveToLastScreen();

    if (doenca.id == null) {
      _showAlertDialog('Status', 'Nenhuma doença foi apagada');
      return;
    }

    int result = await helper.apagarDoenca(doenca.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Doença apagada com sucesso');
    } else {
      _showAlertDialog('Status', 'Erro ao apagar doença');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}