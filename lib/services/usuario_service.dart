import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/usuario.dart';
import '../models/filme.dart';

class UsuarioService {
  Future<Usuario> getUsuario(int id) async {
    try {
      final response = await SupabaseConfig.client
          .from('usuarios')
          .select()
          .eq('id', id)
          .single();
      
      return Usuario.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao carregar usuário: $e');
    }
  }
  
  Future<List<Filme>> getFilmesAssistidos(int usuarioId) async {
    try {
      final response = await SupabaseConfig.client
          .from('filmes_assistidos')
          .select('filmes(*)')
          .eq('usuario_id', usuarioId);
      
      if (response.isEmpty) {
        return [];
      }
      
      final List<Filme> filmes = [];
      for (var item in response) {
        filmes.add(Filme.fromJson(item['filmes']));
      }
      return filmes;
    } catch (e) {
      return [];
    }
  }
  
  Future<void> atualizarUsuario(int usuarioId, String nome, String bio, String fotoUrl) async {
    try {
      await SupabaseConfig.client
          .from('usuarios')
          .update({
            'nome': nome,
            'bio': bio,
            'foto_url': fotoUrl,
          })
          .eq('id', usuarioId);
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }
  
  Future<void> adicionarFilmeAssistido(int usuarioId, int filmeId) async {
    try {
      await SupabaseConfig.client
          .from('filmes_assistidos')
          .insert({
            'usuario_id': usuarioId,
            'filme_id': filmeId,
          });
    } catch (e) {
      print('Erro ao adicionar filme assistido: $e');
    }
  }
}