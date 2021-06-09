import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/visoes/menu.dart';


class HomePage extends StatelessWidget {

  final TextEditingController _tedLogin = TextEditingController();
  final TextEditingController _tedSenha = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String perfilUsuario = 'Médico';
  TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: _body(context),
    );
  }

  _body(context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
      color: Colors.white,
      child: ListView(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _pageView(),
                _textFormFieldLogin(),
                SizedBox(height: 10),
                _textFormFieldSenha(),
                SizedBox(height: 40),
                _dropdownButtonFormField(context),
                Container(
                height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _entrarButton(context),
                      _cadastrarButton(context)
                    ],
                  ),
                ),

              ]
          ),
      ],
    ));
  }

  Container _pageView() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      height: 150,
      child: PageView(
        children: <Widget>[
          Image.asset(
            "images/hope_logo.png",
            width: 10,
            height: 50,
          ),
        ],
      ),
    );
  }

  TextFormField _textFormFieldLogin() {
    return TextFormField(
        controller: _tedLogin,
        validator: _validarLogin,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Login",
            labelStyle: textStyle,
            hintText: "Informe o login"
        )
    );
  }

  TextFormField _textFormFieldSenha() {
    return TextFormField(
        controller: _tedSenha,
        validator: _validarSenha,
        obscureText: true,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: textStyle,
            hintText: "Informe a senha"
        )
    );
  }

  String _validarLogin(String text){
    if(text.isEmpty){
      return "Informe o login";
    }
    return null;
  }

  String _validarSenha(String text){
    if(text.isEmpty){
      return "Informe a senha";
    }
    return null;
  }

  DropdownButtonFormField<String> _dropdownButtonFormField(BuildContext context){
    return DropdownButtonFormField(
      value: perfilUsuario,
      onChanged: (value) {
        debugPrint('Something changed in Perfil Field');
        perfilUsuario = value;
      },
      decoration: InputDecoration(
          labelText: 'Perfil',
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
    );
  }

  _entrarButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Entrar"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return menu();
        }));
      },
    );
  }

  _cadastrarButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cadastrar"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return menu();
        }));
      },
    );
  }
}
