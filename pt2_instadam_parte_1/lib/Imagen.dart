class Imagen {
  String ImageUrl;
  String Usuario;
  int Likes;

  Imagen({
    required this.ImageUrl,
    required this.Usuario,
    this.Likes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': ImageUrl,
      'Usuario': Usuario,
      'Likes': Likes,
    };
  }

  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      ImageUrl: json['ImageUrl'],
      Usuario: json['Usuario'],
      Likes: json['Likes'],
    );
  }
}

