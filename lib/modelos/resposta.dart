import 'dart:convert';

import 'package:hope/modelos/pergunta.dart';

class Resposta {

  int _id;
  int _valor;
  Pergunta _pergunta;

  Resposta(this._valor, this._pergunta);

  Resposta.withId(this._id, this._valor, this._pergunta);

  Resposta.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _valor = json['texto'] as int,
        _pergunta = json['pergunta'] == null ? null : Pergunta.fromJson(jsonDecode(json['pergunta']));

  Map<String, dynamic> toJson() => _$RespostaToJson(this);

  Map<String, dynamic> _$RespostaToJson(Resposta instance) => <String, dynamic>{
    'id': instance._id,
    'valor': instance._valor,
    'pergunta': jsonEncode(instance._pergunta)
  };

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  bool eCorreta(){
    if(_pergunta.gabarito==_valor) return true;
    else return false;
  }

  int get valor => _valor;

  set valor(int value) {
    _valor = value;
  }

  Pergunta get pergunta => _pergunta;

  set pergunta(Pergunta value) {
    _pergunta = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resposta &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _valor == other._valor &&
          _pergunta == other._pergunta;

  @override
  int get hashCode => _id.hashCode ^ _valor.hashCode ^ _pergunta.hashCode;

}