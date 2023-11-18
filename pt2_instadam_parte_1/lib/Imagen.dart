class Imagen {
  String ImageUrl;
  String Usuario;
  int Likes;
  List<String> Comentarios;

  Imagen({
    required this.ImageUrl,
    required this.Usuario,
    this.Likes = 0,
    this.Comentarios = const [], // Cambiado a String
  });

  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': ImageUrl,
      'Usuario': Usuario,
      'Likes': Likes,
      'Comentarios': Comentarios,
    };
  }

  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      ImageUrl: json['ImageUrl'],
      Usuario: json['Usuario'],
      Likes: json['Likes'],
      Comentarios: List<String>.from(json['Comentarios'] ?? ''),
    );
  }
}
