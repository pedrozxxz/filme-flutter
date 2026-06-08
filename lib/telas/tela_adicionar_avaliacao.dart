import 'package:flutter/material.dart';
import '../services/filme_service.dart';
import '../services/avaliacao_service.dart';
import '../models/filme.dart';
import '../models/avaliacao.dart';
import '../widgets/avaliacao_estrelas.dart';

class TelaAdicionarAvaliacao extends StatefulWidget {
  final int usuarioId;

  const TelaAdicionarAvaliacao({Key? key, required this.usuarioId}) : super(key: key);

  @override
  State<TelaAdicionarAvaliacao> createState() => _TelaAdicionarAvaliacaoState();
}

class _TelaAdicionarAvaliacaoState extends State<TelaAdicionarAvaliacao> {
  late FilmeService _filmeService;
  late AvaliacaoService _avaliacaoService;
  List<Filme> _filmes = [];
  Filme? _filmeSelecionado;
  int _nota = 3;
  final TextEditingController _comentarioController = TextEditingController();
  bool _isLoading = false;
  bool _isCarregandoFilmes = true;

  @override
  void initState() {
    super.initState();
    _filmeService = FilmeService();
    _avaliacaoService = AvaliacaoService();
    _carregarFilmes();
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _carregarFilmes() async {
    setState(() => _isCarregandoFilmes = true);
    try {
      final filmes = await _filmeService.getAllFilmes();
      setState(() {
        _filmes = filmes;
        _isCarregandoFilmes = false;
      });
    } catch (e) {
      setState(() => _isCarregandoFilmes = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar filmes: $e')),
        );
      }
    }
  }

  Future<void> _salvarAvaliacao() async {
    if (_filmeSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um filme')),
      );
      return;
    }

    if (_comentarioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um comentário')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final avaliacao = Avaliacao(
        usuarioId: widget.usuarioId,
        filmeId: _filmeSelecionado!.id!,
        nota: _nota,
        comentario: _comentarioController.text,
        curtidas: 0,
      );

      await _avaliacaoService.adicionarAvaliacao(avaliacao);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação adicionada com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar avaliação: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
        backgroundColor: Colors.black,
      ),
      body: _isCarregandoFilmes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione o Filme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Filme>(
                    value: _filmeSelecionado,
                    hint: const Text('Escolha um filme'),
                    isExpanded: true,
                    items: _filmes.map((filme) {
                      return DropdownMenuItem(
                        value: filme,
                        child: Text(
                          filme.titulo,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filmeSelecionado = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sua Nota',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        AvaliacaoEstrelas(nota: _nota.toDouble(), tamanho: 40),
                        const SizedBox(height: 8),
                        Text(
                          '$_nota/5',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: _nota.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: Colors.amber,
                          onChanged: (value) {
                            setState(() {
                              _nota = value.round();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Seu Comentário',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _comentarioController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'O que você achou do filme?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _salvarAvaliacao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar Avaliação'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}