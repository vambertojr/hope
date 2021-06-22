class Doenca {

  int _id;
  String _nome;
  String _descricao;
  String _agenteEtiologico; //causada por bactéria, fungo, vírus, protozoário
  bool _ativa;

  Doenca(this._nome, this._agenteEtiologico, [this._descricao]):
        _ativa = true;

  Doenca.withId(this._id, this._nome, this._agenteEtiologico, [this._descricao]):
        _ativa = true;

  Doenca.fromJson(Map<String, dynamic> json)
    : _nome = json['nome'] as String,
      _agenteEtiologico = json['agenteEtiologico'] as String,
      _descricao = json['descricao'] as String,
      _id = json['id'] as int,
      _ativa = _converterFlagParaBool(json);

  Map<String, dynamic> toJson() => _$DoencaToJson(this);

  Map<String, dynamic> _$DoencaToJson(Doenca instance) => <String, dynamic>{
    'id': instance._id,
    'nome': instance._nome,
    'descricao': instance._descricao,
    'agenteEtiologico': instance._agenteEtiologico,
    'ativa': instance._ativa ? 1 : 0,
  };

  static bool _converterFlagParaBool(Map<String, dynamic> json){
    int valor = json['ativa'] as int;
    return valor==0 ? false : true;
  }

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

  bool get ativa => _ativa;

  set ativa(bool value) {
    _ativa = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Doenca &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _nome == other._nome &&
          _descricao == other._descricao &&
          _agenteEtiologico == other._agenteEtiologico &&
          _ativa == other._ativa;

  @override
  int get hashCode =>
      _id.hashCode ^
      _nome.hashCode ^
      _descricao.hashCode ^
      _agenteEtiologico.hashCode ^
      _ativa.hashCode;

}







