import 'filme.dart';

class Usuario {
  final int? id;
  final String nome;
  final String fotoUrl;
  final String bio;
  final int filmesAssistidos;
  final int seguidores;
  final int seguindo;
  final String? email;
  final List<Filme>? filmesAvaliados;

  Usuario({
    this.id,
    required this.nome,
    required this.fotoUrl,
    required this.bio,
    required this.filmesAssistidos,
    required this.seguidores,
    required this.seguindo,
    this.email,
    this.filmesAvaliados,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      fotoUrl: json['foto_url'] ?? '',
      bio: json['bio'] ?? '',
      filmesAssistidos: json['filmes_assistidos'] ?? 0,
      seguidores: json['seguidores'] ?? 0,
      seguindo: json['seguindo'] ?? 0,
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'foto_url': fotoUrl,
      'bio': bio,
      'filmes_assistidos': filmesAssistidos,
      'seguidores': seguidores,
      'seguindo': seguindo,
      'email': email,
    };
  }
}