import 'package:hope/controladores/login_controller.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_usuario.dart';

class UsuarioController {

  Usuario _usuario;
  RepositorioUsuario _repositorioUsuarios;

  UsuarioController(this._usuario):
        _repositorioUsuarios = RepositorioUsuario();

  Future<int> apagar() async {
    _usuario.ativo = false;
    return await _repositorioUsuarios.atualizarUsuario(_usuario);
  }

  Future<int> salvar() async {
    int resultado;
    bool existe = await _existeUsuarioComMesmoLogin();
    if(existe) resultado = -1;
    else if(_usuario.id == null){
      resultado = await _repositorioUsuarios.inserirUsuario(_usuario);
    } else {
      resultado = await _repositorioUsuarios.atualizarUsuario(_usuario);
    }
    return resultado;
  }

  Future<bool> _existeUsuarioComMesmoLogin() async {
    return await _repositorioUsuarios.existeUsuarioAtivoComLogin(_usuario);
  }

  Future<Usuario> autenticar() async {
    Usuario usuario = await _repositorioUsuarios.getUsuario(_usuario);
    if(usuario != null){
      LoginController loginController = LoginController();
      loginController.registrarLogin(usuario);
    }
    return usuario;
  }

}