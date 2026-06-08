import 'package:flutter/material.dart';
import '../services/filme_service.dart';
import '../models/filme.dart';

class TelaDescobrir extends StatefulWidget {
  final int usuarioId;

  const TelaDescobrir({Key? key, required this.usuarioId}) : super(key: key);

  @override
  State<TelaDescobrir> createState() => _TelaDescobrirState();
}

class _TelaDescobrirState extends State<TelaDescobrir> {
  late FilmeService _filmeService;
  List<Filme> _filmes = [];
  List<Filme> _filmesFiltrados = [];
  bool _isLoading = true;
  final TextEditingController _buscaController = TextEditingController();

  // URLs de exemplo que funcionam
  final List<Map<String, String>> _sugestoesImagens = [
    {'nome': 'Oppenheimer', 'url': 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg'},
    {'nome': 'Barbie', 'url': 'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg'},
    {'nome': 'John Wick 4', 'url': 'https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg'},
    {'nome': 'Duna 2', 'url': 'https://image.tmdb.org/t/p/w500/8BVD0TzYpUO2xDtKRE4M3Oy7D5N.jpg'},
    {'nome': 'Missão Impossível', 'url': 'https://image.tmdb.org/t/p/w500/3R9G4rcc0ZOO0k0HqJlUoYrJ1zI.jpg'},
    {'nome': 'Placeholder', 'url': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=300'},
  ];

  @override
  void initState() {
    super.initState();
    _filmeService = FilmeService();
    _carregarFilmes();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarFilmes() async {
    setState(() => _isLoading = true);
    try {
      final filmes = await _filmeService.getAllFilmes();
      setState(() {
        _filmes = filmes;
        _filmesFiltrados = filmes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar filmes: $e')),
        );
      }
    }
  }

  void _filtrarFilmes(String termo) {
    setState(() {
      if (termo.isEmpty) {
        _filmesFiltrados = _filmes;
      } else {
        _filmesFiltrados = _filmes
            .where((filme) =>
                filme.titulo.toLowerCase().contains(termo.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _adicionarFilme() async {
    final tituloController = TextEditingController();
    final urlController = TextEditingController(text: _sugestoesImagens[0]['url']); // URL padrão
    final avaliacaoController = TextEditingController(text: '4.0');
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Adicionar Novo Filme'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título do Filme *',
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
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL do Pôster *',
                        border: OutlineInputBorder(),
                        helperText: 'Use uma URL de imagem válida',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a URL do pôster';
                        }
                        if (!value.startsWith('http')) {
                          return 'URL deve começar com http:// ou https://';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sugestões de URLs (clique para usar):',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sugestoesImagens.map((sugestao) {
                        return ActionChip(
                          label: Text(sugestao['nome']!, style: const TextStyle(fontSize: 12)),
                          onPressed: () {
                            setDialogState(() {
                              urlController.text = sugestao['url']!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Prévia da imagem
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: urlController.text.isNotEmpty
                          ? Image.network(
                              urlController.text,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, color: Colors.red, size: 40),
                                      SizedBox(height: 8),
                                      Text('URL inválida ou imagem não encontrada'),
                                    ],
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text('Prévia da imagem aparecerá aqui')),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: avaliacaoController,
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
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final novoFilme = Filme(
                        titulo: tituloController.text.trim(),
                        posterUrl: urlController.text.trim(),
                        avaliacao: double.parse(avaliacaoController.text),
                      );
                      
                      print('Salvando filme: ${novoFilme.titulo}');
                      print('URL da imagem: ${novoFilme.posterUrl}');
                      
                      await _filmeService.adicionarFilme(novoFilme);
                      await _carregarFilmes();
                      
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filme adicionado com sucesso!')),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao adicionar filme: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Salvar Filme'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarFilme,
            tooltip: 'Adicionar Filme',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                hintText: 'Buscar filmes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          _filtrarFilmes('');
                        },
                      )
                    : null,
              ),
              onChanged: _filtrarFilmes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filmesFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.movie, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              _buscaController.text.isEmpty
                                  ? 'Nenhum filme encontrado'
                                  : 'Nenhum filme encontrado para "${_buscaController.text}"',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            if (_buscaController.text.isEmpty)
                              ElevatedButton.icon(
                                onPressed: _adicionarFilme,
                                icon: const Icon(Icons.add),
                                label: const Text('Adicionar Filme'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _filmesFiltrados.length,
                        itemBuilder: (context, index) {
                          final filme = _filmesFiltrados[index];
                          return Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    filme.posterUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.broken_image, size: 40),
                                            SizedBox(height: 4),
                                            Text('Sem imagem', style: TextStyle(fontSize: 10)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                filme.titulo,
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}