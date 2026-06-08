import 'filme.dart';
import 'usuario.dart';

class Avaliacao {
  final int? id;
  final int usuarioId;
  final int filmeId;
  final int nota;
  final String comentario;
  final int curtidas;
  final Usuario? usuario;
  final Filme? filme;
  final DateTime? createdAt;
  bool curtidoPeloUsuario;

  Avaliacao({
    this.id,
    required this.usuarioId,
    required this.filmeId,
    required this.nota,
    required this.comentario,
    required this.curtidas,
    this.usuario,
    this.filme,
    this.createdAt,
    this.curtidoPeloUsuario = false,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'],
      usuarioId: json['usuario_id'],
      filmeId: json['filme_id'],
      nota: json['nota'],
      comentario: json['comentario'],
      curtidas: json['curtidas'],
      usuario: json['usuarios'] != null ? Usuario.fromJson(json['usuarios']) : null,
      filme: json['filmes'] != null ? Filme.fromJson(json['filmes']) : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      curtidoPeloUsuario: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'filme_id': filmeId,
      'nota': nota,
      'comentario': comentario,
      'curtidas': curtidas,
    };
  }
  
  Avaliacao copyWith({
    int? curtidas,
    bool? curtidoPeloUsuario,
  }) {
    return Avaliacao(
      id: id,
      usuarioId: usuarioId,
      filmeId: filmeId,
      nota: nota,
      comentario: comentario,
      curtidas: curtidas ?? this.curtidas,
      usuario: usuario,
      filme: filme,
      createdAt: createdAt,
      curtidoPeloUsuario: curtidoPeloUsuario ?? this.curtidoPeloUsuario,
    );
  }
}