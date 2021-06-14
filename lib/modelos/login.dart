import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/usuario_repositorio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {

  static registrarLogin(Usuario usuario) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('login', usuario.login);
    preferences.setString('senha', usuario.senha);
    preferences.setString('papel', usuario.papel);
    preferences.setInt('status', 1);
    preferences.commit();
  }

  static registrarLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('login', '');
    preferences.setString('senha', '');
    preferences.setString('papel', '');
    preferences.setInt('status', 0);
    preferences.commit();
  }

  static Future<Usuario> getUsuarioLogado() async {
    Usuario usuarioEncontrado;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var login = preferences.getString('login');
    var senha = preferences.getString('senha');
    var status = preferences.getInt('status');

    if (login != null && status == 1) {
      UsuarioRepositorio usuarioRepositorio = new UsuarioRepositorio();
      usuarioEncontrado =
      await usuarioRepositorio.getUsuario(new Usuario(login, senha, ''));
    }
    return usuarioEncontrado;
  }


}