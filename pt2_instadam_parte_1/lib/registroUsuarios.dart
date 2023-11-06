import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Usuario {
  String nombre;
  String correo;

  Usuario({required this.nombre, required this.correo});

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      correo: json['correo'],
    );
  }
}

Future<void> registrarUsuario(Usuario usuario) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/datosusuarios.json');
    List<dynamic> usuarios = [];

    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      usuarios = json.decode(jsonContent);
    }

    usuarios.add(usuario.toJson());
    await file.writeAsString(json.encode(usuarios));

    // Verificar que los datos se hayan guardado correctamente
    final newJsonContent = await file.readAsString();
    print('Datos guardados en el archivo JSON: $newJsonContent');
  } catch (e) {
    print("Error al registrar usuario: $e");
  }
}


class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();

  void _registrarUsuario() {
    String nombre = nombreController.text;
    String correo = correoController.text;

    if (nombre.isNotEmpty && correo.isNotEmpty) {
      Usuario usuario = Usuario(nombre: nombre, correo: correo);
      registrarUsuario(usuario);

      // Limpia los campos después del registro
      nombreController.clear();
      correoController.clear();

      // Puedes agregar aquí una notificación o redirección a otra pantalla
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuarios'),
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
              onPressed: _registrarUsuario,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
