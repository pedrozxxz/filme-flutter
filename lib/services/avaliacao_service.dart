import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/avaliacao.dart';

class AvaliacaoService {
  final _client = SupabaseConfig.client;
  
  Future<List<Avaliacao>> getFeedAvaliacoes(int usuarioId) async {
    try {
      final response = await _client
          .from('avaliacoes')
          .select('*, usuarios(*), filmes(*)')
          .order('created_at', ascending: false);
      
      List<Avaliacao> avaliacoes = (response as List)
          .map((json) => Avaliacao.fromJson(json))
          .toList();
      
      // Verificar quais avaliações o usuário curtiu
      for (var i = 0; i < avaliacoes.length; i++) {
        final curtiu = await verificarSeUsuarioCurtiu(usuarioId, avaliacoes[i].id!);
        avaliacoes[i] = avaliacoes[i].copyWith(curtidoPeloUsuario: curtiu);
      }
      
      return avaliacoes;
    } catch (e) {
      throw Exception('Erro ao carregar feed: $e');
    }
  }
  
  Future<Avaliacao> adicionarAvaliacao(Avaliacao avaliacao) async {
    try {
      final response = await _client
          .from('avaliacoes')
          .insert(avaliacao.toJson())
          .select('*, usuarios(*), filmes(*)')
          .single();
      
      return Avaliacao.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao adicionar avaliação: $e');
    }
  }
  
  Future<void> curtirAvaliacao(int usuarioId, int avaliacaoId) async {
    try {
      // Adicionar à tabela de curtidas
      await _client
          .from('curtidas_usuarios')
          .insert({
            'usuario_id': usuarioId,
            'avaliacao_id': avaliacaoId,
          });
      
      // Incrementar contador de curtidas
      await _client.rpc('incrementar_curtidas', params: {
        'avaliacao_id': avaliacaoId,
      });
    } catch (e) {
      throw Exception('Erro ao curtir avaliação: $e');
    }
  }
  
  Future<void> descurtirAvaliacao(int usuarioId, int avaliacaoId) async {
    try {
      // Remover da tabela de curtidas
      await _client
          .from('curtidas_usuarios')
          .delete()
          .match({
            'usuario_id': usuarioId,
            'avaliacao_id': avaliacaoId,
          });
      
      // Decrementar contador de curtidas
      await _client.rpc('decrementar_curtidas', params: {
        'avaliacao_id': avaliacaoId,
      });
    } catch (e) {
      throw Exception('Erro ao descurtir avaliação: $e');
    }
  }
  
  Future<bool> verificarSeUsuarioCurtiu(int usuarioId, int avaliacaoId) async {
    try {
      final response = await _client
          .from('curtidas_usuarios')
          .select()
          .match({
            'usuario_id': usuarioId,
            'avaliacao_id': avaliacaoId,
          });
      
      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}