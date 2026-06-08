import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../services/filme_service.dart';
import '../models/usuario.dart';
import '../models/filme.dart';

class TelaPerfil extends StatefulWidget {
  final int usuarioId;

  const TelaPerfil({
    Key? key,
    required this.usuarioId,
  }) : super(key: key);

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  Usuario? _usuario;
  List<Filme> _filmesAssistidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() => _isLoading = true);
    try {
      final usuarioService = UsuarioService();
      final filmeService = FilmeService();
      
      final usuario = await usuarioService.getUsuario(widget.usuarioId);
      final filmes = await usuarioService.getFilmesAssistidos(widget.usuarioId);
      
      setState(() {
        _usuario = usuario;
        _filmesAssistidos = filmes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar perfil: $e')),
        );
      }
    }
  }

  void _editarPerfil() {
  if (_usuario == null) return;
  
  final nomeController = TextEditingController(text: _usuario!.nome);
  final bioController = TextEditingController(text: _usuario!.bio);
  final fotoUrlController = TextEditingController(text: _usuario!.fotoUrl);
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Perfil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bioController,
            decoration: const InputDecoration(
              labelText: 'Biografia',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: fotoUrlController,
            decoration: const InputDecoration(
              labelText: 'URL da Foto',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final usuarioService = UsuarioService();
              
              // Usando o método corrigido com parâmetros separados
              await usuarioService.atualizarUsuario(
                _usuario!.id!,  // Usando o id que não é nulo
                nomeController.text,
                bioController.text,
                fotoUrlController.text,
              );
              
              await _carregarPerfil();
              
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil atualizado!')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro: $e')),
                );
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editarPerfil,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _usuario!.fotoUrl.isNotEmpty
                        ? NetworkImage(_usuario!.fotoUrl)
                        : null,
                    child: _usuario!.fotoUrl.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _usuario!.nome,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _usuario!.bio.isEmpty ? 'Sem biografia' : _usuario!.bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoItem('${_usuario!.filmesAssistidos}', 'Assistidos'),
                      _buildInfoItem('${_usuario!.seguidores}', 'Seguidores'),
                      _buildInfoItem('${_usuario!.seguindo}', 'Seguindo'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton(
                      onPressed: _editarPerfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text('Editar Perfil'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filmes Avaliados',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _filmesAssistidos.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Text('Nenhum filme avaliado ainda'),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _filmesAssistidos.length,
                          itemBuilder: (context, index) {
                            final filme = _filmesAssistidos[index];
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
                                          child: const Icon(Icons.broken_image),
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
                              ],
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(String valor, String rotulo) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          rotulo,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}