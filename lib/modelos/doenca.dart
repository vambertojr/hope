class Doenca {

  int _id;
  String _nome;
  String _descricao;
  String _agenteEtiologico; //causada por bactéria, fungo, vírus, protozoário

  Doenca(this._nome, this._agenteEtiologico, [this._descricao]);

  Doenca.withId(this._id, this._nome, this._agenteEtiologico, [this._descricao]);

  Doenca.fromJson(Map<String, dynamic> json)
    : _nome = json['nome'] as String,
      _agenteEtiologico = json['agenteEtiologico'] as String,
      _descricao = json['descricao'] as String,
      _id = json['id'] as int;

  Map<String, dynamic> toJson() => _$DoencaToJson(this);

  Map<String, dynamic> _$DoencaToJson(Doenca instance) => <String, dynamic>{
    'id': instance._id,
    'nome': instance._nome,
    'descricao': instance._descricao,
    'agenteEtiologico': instance._agenteEtiologico,
  };

  int get id => _id;

  String get nome => _nome;

  String get descricao => _descricao;

  String get agenteEtiologico => _agenteEtiologico;

  set nome(String nome) {
    if (nome.length <= 255) {
      this._nome = nome;
    }
  }

  set agenteEtiologico(String agente) {
    if (agente.length <= 50) {
      this._agenteEtiologico = agente;
    }
  }

  set descricao(String descricao) {
    if (descricao.length <= 2000) {
      this._descricao = descricao;
    }
  }

}







