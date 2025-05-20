import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/consultas_provider.dart';
import '../provider/clientes_provider.dart';
import '../model/consultas.dart';

class AgendarScreen extends StatefulWidget {
  const AgendarScreen({super.key});

  @override
  State<AgendarScreen> createState() => _AgendarScreenState();
}

class _AgendarScreenState extends State<AgendarScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dataHoraSelecionada;
  String? _especialidade;
  String? _medico;
  String? _uidCliente;

  final List<String> _opcoesEspecialidade = [
    'Clínica Geral',
    'Pediatria',
    'Ginecologia e Obstetrícia',
    'Cardiologia',
    'Ortopedia',
    'Neurologia',
    'Psiquiatria',
    'Dermatologia',
  ];

  final List<String> _opcoesMedico = [
    'Médico - Clínica Geral',
    'Médico - Pediatria',
    'Médico - Ginecologia e Obstetrícia',
    'Médico - Cardiologia',
    'Médico - Ortopedia',
    'Médico - Neurologia',
    'Médico - Psiquiatria',
    'Médico - Dermatologia',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientesProvider>(context, listen: false).carregarClientes();
    });
  }

  Future<void> _selecionarDataHora() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      final horaSelecionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (horaSelecionada != null) {
        setState(() {
          _dataHoraSelecionada = DateTime(
            dataSelecionada.year,
            dataSelecionada.month,
            dataSelecionada.day,
            horaSelecionada.hour,
            horaSelecionada.minute,
          );
        });
      }
    }
  }

  Future<void> _salvarConsulta() async {
    if (_formKey.currentState!.validate() && _dataHoraSelecionada != null) {
      final novaConsulta = ConsultaModel(
        uidConsulta: const Uuid().v4(),
        uidCliente: _uidCliente!,
        dataHora: _dataHoraSelecionada!,
        especialidade: _especialidade!,
        medico: _medico!,
      );

      await Provider.of<ConsultasProvider>(context, listen: false)
          .agendarConsulta(novaConsulta);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta agendada!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<ClientesProvider>(context).clientes;

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Consulta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _uidCliente,
                decoration: const InputDecoration(labelText: 'Paciente'),
                items: clientes
                    .map((cliente) => DropdownMenuItem(
                          value: cliente.uidCliente,
                          child: Text(cliente.nome),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _uidCliente = value),
                validator: (value) =>
                    value == null ? 'Selecione um paciente' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _especialidade,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                items: _opcoesEspecialidade
                    .map((opcao) => DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _especialidade = value),
                validator: (value) =>
                    value == null ? 'Selecione uma especialidade' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _medico,
                decoration: const InputDecoration(labelText: 'Médico'),
                items: _opcoesMedico
                    .map((opcao) => DropdownMenuItem(
                          value: opcao,
                          child: Text(opcao),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _medico = value),
                validator: (value) =>
                    value == null ? 'Selecione um médico' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selecionarDataHora,
                child: const Text('Selecionar Data e Hora'),
              ),
              if (_dataHoraSelecionada != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Selecionado: ${_dataHoraSelecionada!.day.toString().padLeft(2, '0')}/'
                    '${_dataHoraSelecionada!.month.toString().padLeft(2, '0')}/'
                    '${_dataHoraSelecionada!.year} às '
                    '${_dataHoraSelecionada!.hour.toString().padLeft(2, '0')}:'
                    '${_dataHoraSelecionada!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarConsulta,
                child: const Text('Agendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
