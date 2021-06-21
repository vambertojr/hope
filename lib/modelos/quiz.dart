import 'dart:convert';

import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/modelos/usuario.dart';

class Quiz {

  int _id;
  String _titulo;
  DateTime _data;
  Usuario _usuario;
  Doenca _doenca;
  int _totalPerguntas;
  List<Resposta> _perguntas;
  int _pontuacao;
  int status; //0 - a iniciar, 1 - em andamento, 2 - finalizado

  Quiz(this._titulo, this._usuario, this._doenca, this._totalPerguntas, this._perguntas, this._pontuacao):
        _data = DateTime.now();

  Quiz.withId(this._id, this._titulo, this._usuario, this._doenca, this._totalPerguntas, this._perguntas, this._pontuacao):
        _data = DateTime.now();

  Quiz.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _titulo = json['titulo'] as String,
        _data = json['data'] as DateTime,
        _usuario = json['usuario'] == null ? null : Usuario.fromJson(jsonDecode(json['usuario'])),
        _doenca = json['doenca'] == null ? null : Doenca.fromJson(jsonDecode(json['doenca'])),
        _totalPerguntas = json['totalPerguntas'] as int,
        _perguntas = json['perguntas'] == null ? null : _initPerguntas(json['perguntas']),
        _pontuacao = json['pontuacao'] as int;

  Map<String, dynamic> toJson() => _$QuizToJson(this);

  Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
    'id': instance._id,
    'titulo': instance._titulo,
    'data': instance._data,
    'usuario': jsonEncode(instance._usuario),
    'doenca': jsonEncode(instance._doenca),
    'totalPerguntas': instance._totalPerguntas,
    'perguntas': jsonEncode(List<dynamic>.from(instance._perguntas.map((x) => x.toJson()))),
    'pontuacao': instance._pontuacao,
  };

  static _initPerguntas(json) {
    List<Resposta>.from(json.decode(json).map((x) => Resposta.fromJson(x)));
  }

  Doenca get doenca => _doenca;

  set doenca(Doenca value) {
    _doenca = value;
  }

  int get totalPerguntas => _totalPerguntas;

  set totalPerguntas(int value) {
    _totalPerguntas = value;
  }

  int get pontuacao => _pontuacao;

  set pontuacao(int value) {
    _pontuacao = value;
  }

  List<Resposta> get perguntas => _perguntas;

  set perguntas(List<Resposta> value) {
    _perguntas = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  DateTime get data => _data;

  set data(DateTime value) {
    _data = value;
  }

  Usuario get usuario => _usuario;

  set usuario(Usuario value) {
    _usuario = value;
  }

  bool foiConcluido(){
    bool resultado = true;
    for(int i=0; i<perguntas.length; i++){
      if(perguntas[i].valor==0 || perguntas[i].valor<0 || perguntas[i].valor>5){
        resultado = false;
        break;
      }
    }
    return resultado;
  }

}