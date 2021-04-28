part of 'general_bloc.dart';

@immutable
abstract class GeneralState {}

class GeneralInitial extends GeneralState {}

//Parte de Login, estado de autenticación exitosa
class AuthSuccesful extends GeneralState {}

//Parte de Login, estado de desautenticación
class Unauthenticate extends GeneralState {}

//Parte de Login, estado de error de autenticación
class AuthError extends GeneralState {}

//Parte de productos, estado de traer data
class CloudStoreGetProducts extends GeneralState {}

//Parte de productos, estado de error de traer data
class CloudStoreGetProductsError extends GeneralState {}
