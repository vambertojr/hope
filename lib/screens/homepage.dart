import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/screens/login.dart';


import '../todo_detail.dart';
import '../todo_list.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hope"),
        backgroundColor: Colors.teal,
      ),
      body: _body(context),
    );
  }

  _body(context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _pageView(),
            _text(),
            Container(
            height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _button(context),
                ],
              ),
            ),



          ]
      ),
    );
  }

  Container _pageView() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      height: 300,
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

  _text() {
    return Text("Investigar sobre a doenças incluindo, assuntos como "
        "tratamento, progresso do tratamento, ou dificuldades enfrentadas, inclusão social, relatos de profissionais da área, pacientes, familiares e amigos.");

  }

  _button(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("ENTRAR"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          //return TodoList();
          return LoginPage();
        }));
      },
    );
  }
}
