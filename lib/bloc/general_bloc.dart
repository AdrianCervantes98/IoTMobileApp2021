import 'dart:async';

import 'package:IotApp/login/auth_provider.dart';
import 'package:IotApp/models/product.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'general_event.dart';
part 'general_state.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  /*
  **********VARIABLES DE LOGIN**********
  */
  final AuthProvider _authProv = AuthProvider();
  AuthProvider get getAuthProvider => _authProv;

  /*
  **********VARIABLES DE FIREBASE**********
  */
  var firebase = new Firestore();
  List<Product> productsList;
  List<DocumentSnapshot> documentsProdList;
  List<Product> get getProductsList => productsList;

  GeneralBloc() : super(GeneralInitial());

  @override
  Stream<GeneralState> mapEventToState(
    GeneralEvent event,
  ) async* {
    /*
    **********MANEJO DE EVENTOS DE LOGIN**********
    */
    if (event is VerifyUser) {
      try {
        if (await _authProv.userAlreadyLogged())
          yield AuthSuccesful();
        else
          yield Unauthenticate();
      } catch (err) {
        print(err.toString());
        yield AuthError();
      }
    } else if (event is LogOut) {
      try {
        await _authProv.getFirebaseAuth.signOut();
        yield Unauthenticate();
      } catch (err) {
        print(err.toString());
        yield AuthError();
      }
    } else if (event is LoginEmail) {
      try {
        yield AuthSuccesful();
      } catch (err) {
        print(err.toString());
        yield AuthError();
      }
    }
    /*
    **********FIN EVENTOS DE LOGIN**********
    */
    /*
    **********MANEJO EVENTOS DE PRODUCTOS**********
    */
    else if (event is GetProductsEvent) {
      bool dataRetrieved = await _getProducts();
      if (dataRetrieved) {
        yield CloudStoreGetProducts();
      } else {
        yield CloudStoreGetProductsError();
      }
    }
    /*
    **********FIN EVENTOS DE PRODUCTOS**********
    */
  }

  //Función para traer productos
  Future<bool> _getProducts() async {
    try {
      var prods =
          await firebase.collection("productos").getDocuments();
      productsList = prods.documents
          .map((product) => Product(
                beaconId: product["BeaconID"],
                cantidad: product["Cantidad"],
                disponible: product["Disponible"],
                id: product["Id"],
                imagen: product["Imagen"],
                nombre: product["Nombre"]
              ))
          .toList();
      documentsProdList = prods.documents;
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
}
