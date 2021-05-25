import 'dart:async';
import 'package:flutter/material.dart';
import 'file:///C:/Users/vamberto/Projects/hope/lib/todo/todo.dart';
import 'package:hope/todo/database_helper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {

  final String appBarTitle;
  final Todo todo;

  TodoDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Todo todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TodoDetailState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;

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
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
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
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
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

  // Update the title of todo object
  void updateTitle(){
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {  // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else { // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Doença Salva com Sucesso');
    } else {  // Failure
      _showAlertDialog('Status', 'Problema Para Salvar Doença');
    }

  }


  void _delete() async {

    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Doença Apagada Com Sucesso');
    } else {
      _showAlertDialog('Status', 'Ocorreu Um Erro da Deleção da Doença');
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