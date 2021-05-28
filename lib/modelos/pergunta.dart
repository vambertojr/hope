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

  Pergunta(this._doenca, this._texto, this._alternativa1, this._alternativa2,
      this._alternativa3, this._alternativa4, this._alternativa5, this._gabarito);

  Pergunta.withId(this._id, this._doenca, this._texto, this._alternativa1,
      this._alternativa2, this._alternativa3, this._alternativa4,
      this._alternativa5, this._gabarito);

  int get id => _id;

  Doenca get doenca => _doenca;

  String get texto => _texto;

  String get alternativa1 => _alternativa1;

  String get alternativa2 => _alternativa2;

  String get alternativa3 => _alternativa3;

  String get alternativa4 => _alternativa4;

  String get alternativa5 => _alternativa5;

  int get gabarito => _gabarito;

  set doenca(Doenca doenca) {
    this._doenca = doenca;
  }

  set texto(String texto) {
      this._texto = texto;
  }

  set alternativa1(String alternativa1) {
      this._alternativa1 = alternativa1;
  }

  set alternativa2(String alternativa2) {
    this._alternativa2 = alternativa2;
  }

  set alternativa3(String alternativa3) {
    this._alternativa3 = alternativa3;
  }

  set alternativa4(String alternativa4) {
    this._alternativa4 = alternativa4;
  }

  set alternativa5(String alternativa5) {
    this._alternativa5 = alternativa5;
  }

  set gabarito(int gabarito){
    if(gabarito>=1 && gabarito<=5){
      this._gabarito = gabarito;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['doenca'] = _doenca.id;
    map['texto'] = _texto;
    map['alternativa1'] = _alternativa1;
    map['alternativa2'] = _alternativa2;
    map['alternativa3'] = _alternativa3;
    map['alternativa4'] = _alternativa4;
    map['alternativa5'] = _alternativa5;
    map['gabarito'] = _gabarito;

    return map;
  }

  // Extract a Note object from a Map object
  Pergunta.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._doenca.id = map['doenca'];
    this._texto = map['texto'];
    this._alternativa1 = map['alternativa1'];
    this._alternativa2 = map['alternativa2'];
    this._alternativa3 = map['alternativa3'];
    this._alternativa4 = map['alternativa4'];
    this._alternativa5 = map['alternativa5'];
    this._gabarito = map['gabarito'];
  }
}







