import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/clientes_provider.dart';
import 'package:agendar_consultas/model/clientes.dart';
import 'package:uuid/uuid.dart';

class CadastrarScreen extends StatefulWidget {
  final ClienteModel? cliente;
  const CadastrarScreen({super.key, this.cliente});

  @override
  State<CadastrarScreen> createState() => _CadastrarScreenState();
}

class _CadastrarScreenState extends State<CadastrarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();

  late String _uidCliente;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _uidCliente = widget.cliente!.uidCliente;
      _nomeController.text = widget.cliente!.nome;
      _telefoneController.text = widget.cliente!.telefone;
      _dataNascimentoController.text = widget.cliente!.dataNascimento;
    } else {
      _uidCliente = const Uuid().v4(); // novo UID para cadastro
    }
  }

  void _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      final cliente = ClienteModel(
        uidCliente: _uidCliente,
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
      );

      final provider = Provider.of<ClientesProvider>(context, listen: false);
      if (widget.cliente == null) {
        await provider.cadastrarCliente(cliente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
        );
      } else {
        await provider.atualizarCliente(cliente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente atualizado com sucesso!')),
        );
      }

      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cliente == null ? 'Cadastrar Paciente' : 'Editar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a data de nascimento'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarCliente,
                child: Text(widget.cliente == null ? 'Cadastrar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
