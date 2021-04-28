import 'package:firebase_auth/firebase_auth.dart';

/*
Clase para obtener la autenticación de Firebase
*/
class AuthProvider {
  //Instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Método get para la instancia declarada
  FirebaseAuth get getFirebaseAuth => _auth;

  //Función para saber si un usuario ya está loggeado
  Future<bool> userAlreadyLogged() async {
    return await _auth.currentUser() != null;
  }

  //Función para iniciar sesión con el email y contraseña
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
