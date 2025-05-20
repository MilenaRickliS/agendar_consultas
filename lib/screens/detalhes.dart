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
      appBar: AppBar(
        title: const Text('Detalhes da Consulta'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          shadowColor: Colors.teal.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consulta ID',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  consulta.uidConsulta,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32, thickness: 1.5),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${consulta.dataHora.day.toString().padLeft(2, '0')}/'
                            '${consulta.dataHora.month.toString().padLeft(2, '0')}/'
                            '${consulta.dataHora.year}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hora',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${consulta.dataHora.hour.toString().padLeft(2, '0')}:'
                            '${consulta.dataHora.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1.5),
                Text(
                  'Paciente',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(cliente.nome, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(
                  'Especialidade',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(consulta.especialidade, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(
                  'Médico',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(consulta.medico, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
