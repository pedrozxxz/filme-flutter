import 'package:flutter/material.dart';
import '../models/filme.dart';

class ItemDestaque extends StatelessWidget {
  final Filme filme;

  const ItemDestaque({
    Key? key,
    required this.filme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              filme.posterUrl,
              width: 130,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 130,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 50),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filme.titulo,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              filme.avaliacao.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}