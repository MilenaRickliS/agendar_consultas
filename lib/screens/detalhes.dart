import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/consultas.dart';
import '../model/clientes.dart';
import '../provider/clientes_provider.dart';

class DetalhesScreen extends StatelessWidget {
  final ConsultaModel consulta;

  const DetalhesScreen({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);
    final cliente = clientesProvider.clientes.firstWhere(
      (c) => c.uidCliente == consulta.uidCliente,
      orElse: () => ClienteModel(
        uidCliente: '',
        nome: 'Desconhecido',
        dataNascimento: '',
        telefone: '',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Consulta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${consulta.uidConsulta}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Data: ${consulta.dataHora.day}/${consulta.dataHora.month}/${consulta.dataHora.year}'),
                Text('Hora: ${consulta.dataHora.hour}:${consulta.dataHora.minute.toString().padLeft(2, '0')}'),
                const Divider(),
                Text('Paciente: ${cliente.nome}'),
                Text('Especialidade: ${consulta.especialidade}'),
                Text('Médico: ${consulta.medico}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
