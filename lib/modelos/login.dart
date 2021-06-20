import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/usuario_repositorio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {

  static registrarLogin(Usuario usuario) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('login', usuario.login);
    await preferences.setString('senha', usuario.senha);
    await preferences.setString('papel', usuario.papel);
    await preferences.setInt('status', 1);
  }

  static registrarLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('login', '');
    await preferences.setString('senha', '');
    await preferences.setString('papel', '');
    await preferences.setInt('status', 0);
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