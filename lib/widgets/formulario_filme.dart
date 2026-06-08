import 'package:flutter/material.dart';
import '../models/filme.dart';

class FormularioFilme extends StatefulWidget {
  final Function(Filme) onSalvar;

  const FormularioFilme({Key? key, required this.onSalvar}) : super(key: key);

  @override
  State<FormularioFilme> createState() => _FormularioFilmeState();
}

class _FormularioFilmeState extends State<FormularioFilme> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _avaliacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Filme'),
      content: Form(
        key: _formKey,
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
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite a URL do pôster';
                }
                return null;
              },
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
          ],
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