class Filme {
  final int? id;
  final String titulo;
  final String posterUrl;
  final double avaliacao;
  final DateTime? createdAt;

  Filme({
    this.id,
    required this.titulo,
    required this.posterUrl,
    required this.avaliacao,
    this.createdAt,
  });

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: json['id'],
      titulo: json['titulo'],
      posterUrl: json['poster_url'],
      avaliacao: (json['avaliacao'] as num).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'poster_url': posterUrl,
      'avaliacao': avaliacao,
    };
  }
}