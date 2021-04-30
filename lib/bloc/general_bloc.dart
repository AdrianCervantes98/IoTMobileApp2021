import 'dart:async';

import 'package:IotApp/login/auth_provider.dart';
import 'package:IotApp/models/movement.dart';
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
  //Variables para productos
  List<Product> productsList;
  List<DocumentSnapshot> documentsProdList;
  List<Product> get getProductsList => productsList;
  //Variables para movimientos
  var movementList;
  List<DocumentSnapshot> documentsMovList;
  List<Movement> get getMovementsList => movementList;

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
    /*
    **********MANEJO EVENTOS DE MOVIMIENTOS**********
    */
    else if (event is GetMovementsEvent) {
      bool dataRetrieved = await _getMovements();
      if (dataRetrieved) {
        yield CloudStoreGetMovements();
      } else {
        yield CloudStoreGetMovementsError();
      }
    }
    /*
    **********FIN EVENTOS DE MOVIMIENTOS**********
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

  //Función para traer movimientos
  Future<bool> _getMovements() async {
    try {
      var movs =
          await firebase.collection("registros").getDocuments();
      movementList = movs.documents
          .map((movement) => Movement(
                beacon: movement["beacon"],
                timestamp: movement["timestamp"],
                pRef: movement["producto"],
              ))
          .toList();
      await _getProducts();
      await _assignProducts(movementList);
      movementList.forEach((element) {
        element.product =  productsList[0];
      });
      print(movementList.first.product);
      documentsMovList = movs.documents;
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
  
  Future<List<Movement>>_assignProducts(List<Movement> list) async {
    try {
      list.forEach((element) {
        element.product =  _getAssociatedProduct(element.pRef);
      });
    return list;
    } catch (err){
      print(err.toString());
      return null;
    }
  }

  //Función para traer producto asociado al movimiento
  Future<Product> _getAssociatedProduct(DocumentReference ds) async {
    try {
      Product producto;
      await ds.get().then((DocumentSnapshot ds) {
        producto = new Product(
          beaconId: ds.data["BeaconID"],
          cantidad: ds.data["Cantidad"],
          disponible: ds.data["Disponible"],
          id: ds.data["Id"],
          imagen: ds.data["Imagen"],
          nombre: ds.data["Nombre"]
        );
      });
      print(producto.imagen);
      return producto;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

}
