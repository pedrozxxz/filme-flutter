import 'package:flutter/material.dart';
import '../models/filme.dart';
import 'avaliacao_estrelas.dart';

class CardAvaliacao extends StatelessWidget {
  final String usuarioNome;
  final String usuarioFotoUrl;
  final Filme filme;
  final double nota;
  final String comentario;
  final int curtidas;
  final bool curtidoPeloUsuario;
  final VoidCallback onCurtir;

  const CardAvaliacao({
    Key? key,
    required this.usuarioNome,
    required this.usuarioFotoUrl,
    required this.filme,
    required this.nota,
    required this.comentario,
    required this.curtidas,
    required this.curtidoPeloUsuario,
    required this.onCurtir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(usuarioFotoUrl),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuarioNome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Avaliou ${filme.titulo}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    filme.posterUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, size: 40),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvaliacaoEstrelas(nota: nota, tamanho: 18),
                      const SizedBox(height: 8),
                      Text(
                        comentario,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              curtidoPeloUsuario ? Icons.favorite : Icons.favorite_border,
                              color: curtidoPeloUsuario ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                            onPressed: onCurtir,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$curtidas',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          const Text('Responder', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}