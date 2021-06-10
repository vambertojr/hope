import 'package:flutter/material.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/usuario_repositorio.dart';

class CadastroUsuario extends StatefulWidget {

  final String appBarTitle;
  final Usuario usuario;

  CadastroUsuario(this.usuario, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CadastroUsuarioState(this.usuario, this.appBarTitle);
  }

}

class CadastroUsuarioState extends State<CadastroUsuario> {

  UsuarioRepositorio _usuarioRepositorio;

  String appBarTitle;
  Usuario usuario;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  String _papel;

  CadastroUsuarioState(this.usuario, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _usuarioRepositorio = UsuarioRepositorio();
    _loginController = new TextEditingController(text: usuario.login);
    _senhaController = new TextEditingController(text: usuario.senha);
    _papel = usuario.papel?.isEmpty ? 'Médico' : usuario.papel;
  }

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

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
                    controller: _loginController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Login Text Field');
                      atualizarLogin();
                    },
                    decoration: InputDecoration(
                        labelText: 'Login',
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
                    controller: _senhaController,
                    obscureText: true,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Senha Text Field');
                      atualizarSenha();
                    },
                    decoration: InputDecoration(
                        labelText: 'Senha',
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
                    value: _papel,
                    onChanged: (value) {
                      debugPrint('Something changed in Papel Field');
                      _papel = value;
                      atualizarPapel();
                    },
                    decoration: InputDecoration(
                        labelText: 'Papel',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: <String>['Médico', 'Estudante']
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

  void atualizarLogin(){
    usuario.login = _loginController.text;
  }

  void atualizarSenha() {
    usuario.senha = _senhaController.text;
  }

  void atualizarPapel(){
    usuario.papel = _papel;
  }

  void _save() async {

    moveToLastScreen();

    int result;
    if (usuario.id != null) {  // Case 1: Update operation
      result = await _usuarioRepositorio.atualizarUsuario(usuario);
    } else { // Case 2: Insert Operation
      result = await _usuarioRepositorio.inserirUsuario(usuario);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Usuário salvo com sucesso');
    } else {  // Failure
      _showAlertDialog('Status', 'Erro ao salvar usuário');
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