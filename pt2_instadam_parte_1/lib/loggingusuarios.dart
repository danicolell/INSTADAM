import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pt2_instadam_parte_1/PaginaPrincipal.dart';

class LoginScreen extends StatelessWidget {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();

  Future<void> _iniciarSesion(BuildContext context) async {
    String nombre = nombreController.text;
    String correo = correoController.text;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/datosusuarios.json');

      if (await file.exists()) {
        final jsonContent = await file.readAsString();
        final List<dynamic> usuarios = json.decode(jsonContent);

        // Verificar si las credenciales coinciden con algún usuario almacenado
        final usuarioEncontrado = usuarios.firstWhere(
              (usuario) =>
          usuario['nombre'] == nombre && usuario['correo'] == correo,
          orElse: () => null,
        );

        if (usuarioEncontrado != null) {
          // Si las credenciales son válidas, navegar a la pantalla principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaginaPrincipal(nombreUsuario: nombre),
            ),
          );
        } else {
          // Mostrar un mensaje de error si las credenciales no coinciden
          print('Credenciales no válidas');
        }
      } else {
        print('Archivo de usuarios no encontrado');
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INSTADAM - Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: correoController,
              decoration: InputDecoration(
                labelText: 'Correo',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _iniciarSesion(context);
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
