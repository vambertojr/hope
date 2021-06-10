class Usuario {

  int _id;
  String _login;
  String _senha;
  String _papel;

  Usuario(this._login, this._senha, [this._papel]);

  Usuario.withId(this._id, this._login, this._senha, this._papel);

  Usuario.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _login = json['login'] as String,
        _senha = json['senha'] as String,
        _papel = json['papel'] as String;

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
    'id': instance._id,
    'login': instance._login,
    'senha': instance._senha,
    'papel': instance._papel,
  };

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
}