import 'package:flutter/material.dart';
import '../services/avaliacao_service.dart';
import '../services/filme_service.dart';
import '../models/avaliacao.dart';
import '../models/filme.dart';
import '../widgets/card_avaliacao.dart';
import '../widgets/item_destaque.dart';
import 'tela_adicionar_avaliacao.dart';

class TelaFeed extends StatefulWidget {
  final int usuarioId;

  const TelaFeed({Key? key, required this.usuarioId}) : super(key: key);

  @override
  State<TelaFeed> createState() => _TelaFeedState();
}

class _TelaFeedState extends State<TelaFeed> {
  late AvaliacaoService _avaliacaoService;
  late FilmeService _filmeService;
  List<Avaliacao> _avaliacoes = [];
  List<Filme> _filmesEmAlta = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _avaliacaoService = AvaliacaoService();
    _filmeService = FilmeService();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      final filmes = await _filmeService.getFilmesEmAlta();
      final avaliacoes = await _avaliacaoService.getFeedAvaliacoes(widget.usuarioId);
      setState(() {
        _filmesEmAlta = filmes;
        _avaliacoes = avaliacoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  Future<void> _alternarCurtida(Avaliacao avaliacao, int index) async {
    try {
      if (avaliacao.curtidoPeloUsuario) {
        await _avaliacaoService.descurtirAvaliacao(widget.usuarioId, avaliacao.id!);
      } else {
        await _avaliacaoService.curtirAvaliacao(widget.usuarioId, avaliacao.id!);
      }
      
      setState(() {
        _avaliacoes[index] = avaliacao.copyWith(
          curtidas: avaliacao.curtidas + (avaliacao.curtidoPeloUsuario ? -1 : 1),
          curtidoPeloUsuario: !avaliacao.curtidoPeloUsuario,
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao curtir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CineLog',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificações em breve!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaAdicionarAvaliacao(
                    usuarioId: widget.usuarioId,
                  ),
                ),
              );
              if (result == true) {
                _carregarDados();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Destaques da Semana',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 240,
                          child: _filmesEmAlta.isEmpty
                              ? const Center(child: Text('Nenhum filme em destaque'))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  itemCount: _filmesEmAlta.length,
                                  itemBuilder: (context, index) {
                                    return ItemDestaque(filme: _filmesEmAlta[index]);
                                  },
                                ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Feed de Avaliações',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_avaliacoes.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.rate_review, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma avaliação ainda.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Seja o primeiro a avaliar um filme!',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final avaliacao = _avaliacoes[index];
                          if (avaliacao.usuario == null || avaliacao.filme == null) {
                            return const SizedBox.shrink();
                          }
                          return CardAvaliacao(
                            usuarioNome: avaliacao.usuario!.nome,
                            usuarioFotoUrl: avaliacao.usuario!.fotoUrl,
                            filme: avaliacao.filme!,
                            nota: avaliacao.nota.toDouble(),
                            comentario: avaliacao.comentario,
                            curtidas: avaliacao.curtidas,
                            curtidoPeloUsuario: avaliacao.curtidoPeloUsuario,
                            onCurtir: () => _alternarCurtida(avaliacao, index),
                          );
                        },
                        childCount: _avaliacoes.length,
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
    );
  }
}