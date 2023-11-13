import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  TextEditingController comentarioController = TextEditingController();
  List<Map<String, dynamic>> listaDeImagenes = [];

  @override
  void initState() {
    super.initState();
    _cargarImagenes(); // Cargar imágenes al inicio de la página
  }

  void _cargarImagenes() async {
    List<Map<String, dynamic>> imagenes = await _obtenerImagenesDesdeJSON();
    setState(() {
      listaDeImagenes = imagenes;
    });
  }

  Future<void> _escribirImagenesEnJSON(List<Map<String, dynamic>> data) async {
    String jsonData = json.encode(data);
    File file = File('archivos/manejarfotos.json');
    await file.writeAsString(jsonData);
  }

  Future<List<Map<String, dynamic>>> _obtenerImagenesDesdeJSON() async {
    File file = File('archivos/manejarfotos.json');
    if (await file.exists()) {
      String jsonData = await file.readAsString();
      List<dynamic> listaDinamica = json.decode(jsonData);
      return List<Map<String, dynamic>>.from(listaDinamica);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INSTADAM - Pagina Principal'),
      ),
      body: ListView.builder(
        itemCount: listaDeImagenes.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> imagen = listaDeImagenes[index];
          return Card(
            child: Column(
              children: [
                Image.network(imagen['imageUrl']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {
                        _darLike(imagen);
                      },
                    ),
                    Text('${imagen['likes']} Likes'),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        _mostrarDialogoComentario(context, imagen['usuario']);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _darLike(Map<String, dynamic> imagen) {
    setState(() {
      imagen['likes']++;
      _escribirImagenesEnJSON(listaDeImagenes);
    });
  }

  void _subirImagen() {
    // Implementa la lógica para subir imágenes
    // Puedes usar ImagePicker o cualquier otra biblioteca para seleccionar imágenes
    // Agrega la nueva imagen a la listaDeImagenes
    // Guarda la imagen en el archivo JSON
    // Asegúrate de ajustar este método según tu lógica específica
    Map<String, dynamic> nuevaImagen = {
      'imageUrl': 'URL_DE_LA_IMAGEN', // Reemplaza esto con la URL real de la imagen
      'usuario': 'USUARIO_ACTUAL', // Reemplaza esto con el usuario actual
      'likes': 0,
    };

    setState(() {
      listaDeImagenes.add(nuevaImagen);
    });

    _escribirImagenesEnJSON(listaDeImagenes);
  }

  void _mostrarDialogoComentario(BuildContext context, String usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comentar'),
          content: TextField(
            controller: comentarioController,
            decoration: InputDecoration(labelText: 'Escribe tu comentario'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String comentario = comentarioController.text;
                // Puedes almacenar el comentario en el objeto Imagen o en otro lugar
                // Actualizar la interfaz si es necesario
                Navigator.of(context).pop();
              },
              child: Text('Comentar'),
            ),
          ],
        );
      },
    );
  }
}

