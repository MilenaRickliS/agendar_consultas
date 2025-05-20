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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.teal, // cor do header
            onPrimary: Colors.white, // cor do texto do header
            onSurface: Colors.black, // cor dos textos do body
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal, // cor dos botões
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (dataSelecionada != null) {
      final horaSelecionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        ),
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
    if (_formKey.currentState!.validate()) {
      if (_dataHoraSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione a data e hora da consulta'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

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
      appBar: AppBar(
        title: const Text('Agendar Consulta',
          style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _uidCliente,
                      decoration: InputDecoration(
                        labelText: 'Paciente',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal, 
                            width: 2,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.teal, 
                        ),
                      ),
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
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _especialidade,
                      decoration: InputDecoration(
                        labelText: 'Especialidade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal, 
                            width: 2,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.teal, 
                        ),
                      ),
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
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _medico,
                      decoration: InputDecoration(
                        labelText: 'Médico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal, 
                            width: 2,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.teal, 
                        ),
                      ),
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
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: Colors.tealAccent,
                      ),
                      onPressed: _selecionarDataHora,
                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                      label: const Text(
                        'Selecionar Data e Hora',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    if (_dataHoraSelecionada != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Selecionado: ${_dataHoraSelecionada!.day.toString().padLeft(2, '0')}/'
                          '${_dataHoraSelecionada!.month.toString().padLeft(2, '0')}/'
                          '${_dataHoraSelecionada!.year} às '
                          '${_dataHoraSelecionada!.hour.toString().padLeft(2, '0')}:'
                          '${_dataHoraSelecionada!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 30, 51, 49),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        shadowColor: Colors.tealAccent.shade100,
                      ),
                      onPressed: _salvarConsulta,
                      child: const Text(
                        'Agendar Consulta',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
