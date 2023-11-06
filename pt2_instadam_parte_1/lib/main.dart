import 'package:flutter/material.dart';
import 'registroUsuarios.dart'; // Importa el archivo de registro de usuarios

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistroUsuarioScreen(), // Esto define la pantalla de registro de usuarios como pantalla inicial
    );
  }
}
