import 'dart:convert';

import 'package:hope/modelos/doenca.dart';

class Pergunta {

  int _id;
  Doenca _doenca;
  String _texto;
  String _alternativa1;
  String _alternativa2;
  String _alternativa3;
  String _alternativa4;
  String _alternativa5;
  int _gabarito;
  bool _ativa;

  Pergunta(this._doenca, this._texto, this._alternativa1, this._alternativa2,
      this._alternativa3, this._alternativa4, this._alternativa5, this._gabarito):
        _ativa = true;

  Pergunta.withId(this._id, this._doenca, this._texto, this._alternativa1,
      this._alternativa2, this._alternativa3, this._alternativa4,
      this._alternativa5, this._gabarito):
        _ativa = true;

  Pergunta.fromJson(Map<String, dynamic> json)
    : _doenca = json['doenca'] == null ? null : Doenca.fromJson(jsonDecode(json['doenca'])),
      _texto = json['texto'] as String,
      _alternativa1 = json['alternativa1'] as String,
      _alternativa2 = json['alternativa2'] as String,
      _alternativa3 = json['alternativa3'] as String,
      _alternativa4 = json['alternativa4'] as String,
      _alternativa5 = json['alternativa5'] as String,
      _gabarito = json['gabarito'] as int,
      _id = json['id'] as int,
      _ativa = _converterFlagParaBool(json);

  Map<String, dynamic> toJson() => _$PerguntaToJson(this);

  Map<String, dynamic> _$PerguntaToJson(Pergunta instance) => <String, dynamic>{
    'id': instance._id,
    'doenca': jsonEncode(instance._doenca),
    'texto': instance._texto,
    'alternativa1': instance._alternativa1,
    'alternativa2': instance._alternativa2,
    'alternativa3': instance._alternativa3,
    'alternativa4': instance._alternativa4,
    'alternativa5': instance._alternativa5,
    'gabarito': instance._gabarito,
    'ativa': instance._ativa ? 1 : 0,
  };

  static bool _converterFlagParaBool(Map<String, dynamic> json){
    int valor = json['ativa'] as int;
    return valor==0 ? false : true;
  }

  int get gabarito => _gabarito;

  set gabarito(int value) {
    _gabarito = value;
  }

  String get alternativa5 => _alternativa5;

  set alternativa5(String value) {
    _alternativa5 = value;
  }

  String get alternativa4 => _alternativa4;

  set alternativa4(String value) {
    _alternativa4 = value;
  }

  String get alternativa3 => _alternativa3;

  set alternativa3(String value) {
    _alternativa3 = value;
  }

  String get alternativa2 => _alternativa2;

  set alternativa2(String value) {
    _alternativa2 = value;
  }

  String get alternativa1 => _alternativa1;

  set alternativa1(String value) {
    _alternativa1 = value;
  }

  String get texto => _texto;

  set texto(String value) {
    _texto = value;
  }

  Doenca get doenca => _doenca;

  set doenca(Doenca value) {
    _doenca = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  bool get ativa => _ativa;

  set ativa(bool value) {
    _ativa = value;
  }

  String getRespostaCorreta(){
    switch(_gabarito){
      case 1: return _alternativa1;
      case 2: return _alternativa2;
      case 3: return _alternativa3;
      case 4: return _alternativa4;
      case 5: return _alternativa5;
      default: return '';
    }
  }

  int getNumeroAlternativasSemNullEVazio(){
    int alternativasNull = 0;
    List<String> alternativas = [this._alternativa1, this._alternativa2,
      this._alternativa3, this._alternativa4, this._alternativa5];

    for(int i=0; i<alternativas.length; i++){
      if(alternativas[i] == null || alternativas[i] == '') alternativasNull++;
    }

    return (5 - alternativasNull);
  }

  int getNumeroAlternativasSemNull(){
    int alternativasNull = 0;
    List<String> alternativas = [this._alternativa1, this._alternativa2,
      this._alternativa3, this._alternativa4, this._alternativa5];

    for(int i=0; i<alternativas.length; i++){
      if(alternativas[i] == null) alternativasNull++;
    }

    return (5 - alternativasNull);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pergunta &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _doenca == other._doenca &&
          _texto == other._texto &&
          _alternativa1 == other._alternativa1 &&
          _alternativa2 == other._alternativa2 &&
          _alternativa3 == other._alternativa3 &&
          _alternativa4 == other._alternativa4 &&
          _alternativa5 == other._alternativa5 &&
          _gabarito == other._gabarito &&
          _ativa == other._ativa;

  @override
  int get hashCode =>
      _id.hashCode ^
      _doenca.hashCode ^
      _texto.hashCode ^
      _alternativa1.hashCode ^
      _alternativa2.hashCode ^
      _alternativa3.hashCode ^
      _alternativa4.hashCode ^
      _alternativa5.hashCode ^
      _gabarito.hashCode ^
      _ativa.hashCode;

}







