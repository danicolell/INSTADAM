import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'Imagen.dart';

class PaginaPrincipal extends StatefulWidget {
  final String nombreUsuario;

  PaginaPrincipal({required this.nombreUsuario});

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  TextEditingController imageUrlController = TextEditingController();
  List<Imagen> listaDeImagenes = [];

  @override
  void initState() {
    super.initState();
    cargarImagenesDesdeArchivo();
  }

  Future<void> cargarImagenesDesdeArchivo() async {
    try {
      String jsonString = await rootBundle.loadString('assets/manejarfotos.json');
      List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        listaDeImagenes = jsonList.map((json) {
          return Imagen(
            ImageUrl: json['ImageUrl'],
            Usuario: json['nNmbreUsuario'],
            Likes: json['Likes'],
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar imágenes desde el archivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${widget.nombreUsuario}'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _mostrarDialogoSubirImagen(context);
            },
            child: Text('Subir Imagen'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaDeImagenes.length,
              itemBuilder: (context, index) {
                Imagen imagen = listaDeImagenes[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(imagen.ImageUrl),
                      Text('Usuario: ${imagen.Usuario}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {
                              _incrementarLikes(index);
                            },
                          ),
                          Text('${imagen.Likes} Likes'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoSubirImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subir Imagen'),
          content: TextField(
            controller: imageUrlController,
            decoration: InputDecoration(labelText: 'URL de la Imagen'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _subirImagen();
                Navigator.of(context).pop();
              },
              child: Text('Subir'),
            ),
          ],
        );
      },
    );
  }

  void _subirImagen() async {
    String imageUrl = imageUrlController.text;
    String usuario = widget.nombreUsuario; // Puedes obtener el nombre de usuario de la sesión actual

    if (imageUrl.isNotEmpty) {
      Imagen nuevaImagen = Imagen(ImageUrl: imageUrl, Usuario: usuario);
      setState(() {
        listaDeImagenes.add(nuevaImagen);
      });

      await _guardarEnJSON();
    }
  }

  void _incrementarLikes(int index) {
    setState(() {
      listaDeImagenes[index].Likes++;
    });

    _guardarEnJSON();
  }

  Future<void> _guardarEnJSON() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/manejarfotos.json');

      List<Map<String, dynamic>> imagenesJson =
      listaDeImagenes.map((imagen) => imagen.toJson()).toList();

      await file.writeAsString(json.encode(imagenesJson));

      print('Datos guardados en el archivo JSON');
    } catch (e) {
      print("Error al guardar en JSON: $e");
    }
  }
}


