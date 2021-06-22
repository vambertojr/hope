class Usuario {

  int _id;
  String _login;
  String _senha;
  String _papel;
  bool _ativo;

  Usuario(this._login, this._senha, this._papel):
        _ativo = true;

  Usuario.withId(this._id, this._login, this._senha, this._papel):
        _ativo = true;

  Usuario.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _login = json['login'] as String,
        _senha = json['senha'] as String,
        _papel = json['papel'] as String,
        _ativo = _converterFlagParaBool(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
    'id': instance._id,
    'login': instance._login,
    'senha': instance._senha,
    'papel': instance._papel,
    'ativo': instance._ativo ? 1 : 0,
  };

  static bool _converterFlagParaBool(Map<String, dynamic> json){
    int valor = json['ativo'] as int;
    return valor==0 ? false : true;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get login => _login;

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  set login(String value) {
    _login = value;
  }

  String get papel => _papel;

  set papel(String value) {
    _papel = value;
  }

  bool get ativo => _ativo;

  set ativo(bool value) {
    _ativo = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _login == other._login &&
          _senha == other._senha &&
          _papel == other._papel &&
          _ativo == other._ativo;

  @override
  int get hashCode =>
      _id.hashCode ^
      _login.hashCode ^
      _senha.hashCode ^
      _papel.hashCode ^
      _ativo.hashCode;

}