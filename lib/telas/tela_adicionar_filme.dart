import 'package:flutter/material.dart';
import '../services/filme_service.dart';
import '../models/filme.dart';

class TelaAdicionarFilme extends StatefulWidget {
  final Function(Filme) onSalvar;

  const TelaAdicionarFilme({Key? key, required this.onSalvar}) : super(key: key);

  @override
  State<TelaAdicionarFilme> createState() => _TelaAdicionarFilmeState();
}

class _TelaAdicionarFilmeState extends State<TelaAdicionarFilme> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _avaliacaoController = TextEditingController();

  // URLs de exemplo que funcionam
  final List<Map<String, String>> _sugestoesImagens = [
    {'nome': 'Ação', 'url': 'https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg'},
    {'nome': 'Drama', 'url': 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg'},
    {'nome': 'Comédia', 'url': 'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg'},
    {'nome': 'Animação', 'url': 'https://image.tmdb.org/t/p/w500/stKGOm8UyhuLPRVRs7dLfap3Sxj.jpg'},
    {'nome': 'Ficção', 'url': 'https://image.tmdb.org/t/p/w500/8BVD0TzYpUO2xDtKRE4M3Oy7D5N.jpg'},
    {'nome': 'Placeholder', 'url': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=300'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Filme'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título do Filme',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _posterUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL do Pôster',
                  border: OutlineInputBorder(),
                  helperText: 'Use uma URL de imagem válida',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a URL do pôster';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Sugestões de URLs que funcionam:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sugestoesImagens.map((sugestao) {
                  return ActionChip(
                    label: Text(sugestao['nome']!),
                    onPressed: () {
                      setState(() {
                        _posterUrlController.text = sugestao['url']!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avaliacaoController,
                decoration: const InputDecoration(
                  labelText: 'Avaliação (0-5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a avaliação';
                  }
                  final nota = double.tryParse(value);
                  if (nota == null || nota < 0 || nota > 5) {
                    return 'Avaliação deve ser entre 0 e 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_posterUrlController.text.isNotEmpty)
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    _posterUrlController.text,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            Text('URL inválida ou imagem não encontrada'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final filme = Filme(
                titulo: _tituloController.text,
                posterUrl: _posterUrlController.text,
                avaliacao: double.parse(_avaliacaoController.text),
              );
              widget.onSalvar(filme);
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}