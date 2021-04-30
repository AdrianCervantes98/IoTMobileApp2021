part of 'general_bloc.dart';

@immutable
abstract class GeneralEvent {}

class InitEvent extends GeneralEvent {}

//Parte de Login, evento de inicio de sesión con Email
class LoginEmail extends GeneralEvent {
  final String username;
  final String password;

  LoginEmail({@required this.username, @required this.password});
}

//Parte de Login, evento de cierre de sesión
class LogOut extends GeneralEvent {}

//Parte de Login, evento de verificar al usuario
class VerifyUser extends GeneralEvent {}

//Parte de products, evento de traer productos
class GetProductsEvent extends GeneralEvent {}

//Parte de products, evento de traer productos
class GetMovementsEvent extends GeneralEvent {}