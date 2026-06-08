import 'package:flutter/material.dart';

class AvaliacaoEstrelas extends StatelessWidget {
  final double nota;
  final double tamanho;

  const AvaliacaoEstrelas({
    Key? key,
    required this.nota,
    this.tamanho = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < nota.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: tamanho);
        } else if (index < nota && nota > index) {
          return Icon(Icons.star_half, color: Colors.amber, size: tamanho);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: tamanho);
        }
      }),
    );
  }
}