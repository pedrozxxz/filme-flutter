import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/filme.dart';

class FilmeService {
  final _client = SupabaseConfig.client;
  
  Future<List<Filme>> getFilmesEmAlta() async {
    try {
      final response = await _client
          .from('filmes')
          .select()
          .order('avaliacao', ascending: false)
          .limit(10);
      
      return (response as List).map((json) => Filme.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar filmes em alta: $e');
    }
  }
  
  Future<List<Filme>> getAllFilmes() async {
    try {
      final response = await _client
          .from('filmes')
          .select()
          .order('titulo');
      
      return (response as List).map((json) => Filme.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar filmes: $e');
    }
  }
  
  Future<Filme> adicionarFilme(Filme filme) async {
    try {
      final response = await _client
          .from('filmes')
          .insert(filme.toJson())
          .select()
          .single();
      
      return Filme.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao adicionar filme: $e');
    }
  }
  
  Future<void> atualizarAvaliacaoFilme(int filmeId, double novaAvaliacao) async {
    try {
      await _client
          .from('filmes')
          .update({'avaliacao': novaAvaliacao})
          .eq('id', filmeId);
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação do filme: $e');
    }
  }
  
  Future<List<Filme>> buscarFilmes(String termo) async {
    try {
      final response = await _client
          .from('filmes')
          .select()
          .ilike('titulo', '%$termo%')
          .order('titulo');
      
      return (response as List).map((json) => Filme.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}