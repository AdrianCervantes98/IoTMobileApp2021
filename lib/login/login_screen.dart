import 'package:flutter/material.dart';
import '../bloc/general_bloc.dart';
import '../home/home.dart';
import 'auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
Clase que controla la pantalla de Inicio de sesión.
*/

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Variable de Bloc
  GeneralBloc bloc;
  //Llave de formulario
  final _formKey = GlobalKey<FormState>();
  //Instancia de la clase que permite autenticar al usuario con Firebase
  final AuthProvider _auth = AuthProvider();
  //Variable para saber si se esconderá el texto de la contraseña
  bool _isTextHidden = true;
  //Llave de Scaffold para mostrar Snackbars
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //Controlador de usuario
  TextEditingController _usernameController;
  //Controlador de contraseña
  TextEditingController _passwordController;
  //Variables de usuario y contraseña
  String user = '';
  String pw = '';

  //Construcción de widget principal
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        bloc = GeneralBloc()..add(InitEvent());
        return bloc;
      },
      child: BlocBuilder<GeneralBloc, GeneralState>(
        builder: (context, state) {
          if (state is AuthSuccesful) {
            return Home();
          }
          return SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              body: Center(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: _loginBody(),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  //Cuerpo de la pantalla de Login
  Center _loginBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _userTextField(),
            SizedBox(height: 24),
            _passwordTextField(),
            SizedBox(height: 48),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  //Widget de campo de usuario
  Widget _userTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          user = value;
        });
      },
      controller: _usernameController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff94d500),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff94d500),
          ),
        ),
        errorStyle: TextStyle(
          color: Color(0xff94d500),
        ),
        labelText: "Usuario",
        labelStyle: TextStyle(color: Colors.grey[300]),
      ),
      validator: (contenido) {
        if (contenido.isEmpty) {
          return "Ingrese nombre";
        } else {
          return null;
        }
      },
    );
  }

  //Widget de campo de contraseña
  Widget _passwordTextField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          pw = value;
        });
      },
      controller: _passwordController,
      obscureText: _isTextHidden,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff94d500),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff94d500),
          ),
        ),
        errorStyle: TextStyle(
          color: Color(0xff94d500),
        ),
        labelText: "Contraseña",
        labelStyle: TextStyle(color: Colors.grey[300]),
        suffixIcon: IconButton(
          icon: _isTextHidden
              ? Icon(Icons.visibility_off, color: Colors.grey[300])
              : Icon(Icons.visibility, color: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _isTextHidden = !_isTextHidden;
            });
          },
        ),
      ),
      validator: (contenido) {
        if (contenido.isEmpty) {
          return "Ingrese contraseña";
        } else {
          return null;
        }
      },
    );
  }

  //Widget de botón de inicio de sesión
  Widget _loginButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: MaterialButton(
            color: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.account_box_rounded,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: Text(
                    "Iniciar sesión",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _login();
            },
          ),
        ),
      ],
    );
  }

  //Función de validación de inicio de sesión y muestra de Snackbars si faltan campos o hay errores
  _login() async {
    if (_formKey.currentState.validate()) {
      dynamic val = await _auth.signInWithEmailAndPassword(user, pw);
      if (val != null)
        bloc..add(LoginEmail(username: user, password: pw));
      else
        scaffoldKey.currentState
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Usuario y/o contraseña inválidos."),
            ),
          );
    } else {
      scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Usuario y/o contraseña inválidos."),
          ),
        );
    }
  }
}
