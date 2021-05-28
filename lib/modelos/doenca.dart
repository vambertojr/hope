class Doenca {

  int _id;
  String _nome;
  String _descricao;
  String _agenteEtiologico; //causada por bactéria, fungo, vírus, protozoário

  Doenca(this._nome, this._agenteEtiologico, [this._descricao]);

  Doenca.withId(this._id, this._nome, this._agenteEtiologico, [this._descricao]);

  int get id => _id;

  String get nome => _nome;

  String get descricao => _descricao;

  String get agente => _agenteEtiologico;

  set id(int id){
    this._id = id;
  }

  set nome(String nome) {
    if (nome.length <= 255) {
      this._nome = nome;
    }
  }

  set agente(String agente) {
    if (agente.length <= 50) {
      this._agenteEtiologico = agente;
    }
  }

  set descricao(String descricao) {
    if (descricao.length <= 2000) {
      this._descricao = descricao;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['descricao'] = _descricao;
    map['agente'] = _agenteEtiologico;

    return map;
  }

  // Extract a Note object from a Map object
  Doenca.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._descricao = map['descricao'];
    this._agenteEtiologico = map['agente'];
  }
}







