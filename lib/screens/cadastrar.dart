import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/clientes_provider.dart';
import 'package:agendar_consultas/model/clientes.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

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
      _uidCliente = const Uuid().v4();
    }
  }

  String? _validarNome(String? value) {
    if (value == null || value.isEmpty) return 'Informe o nome';
    final nomeValido = RegExp(r"^[A-Za-zÀ-ú\s]+$");
    if (!nomeValido.hasMatch(value)) return 'Use apenas letras e acentos';
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.isEmpty) return 'Informe o telefone';
    final telefoneNumerico = toNumericString(value);
    if (telefoneNumerico.length != 11) return 'Telefone deve conter 11 dígitos numéricos';
    return null;
  }

  String? _validarData(String? value) {
    if (value == null || value.isEmpty) return 'Informe a data de nascimento';
    final dataRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dataRegex.hasMatch(value)) return 'Informe uma data válida';

    try {
      final data = DateFormat('dd/MM/yyyy').parseStrict(value);
      if (data.isAfter(DateTime.now())) {
        return 'Data de nascimento não pode ser futura';
      }
    } catch (e) {
      return 'Data inválida';
    }

    return null;
  }

  void _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      final cliente = ClienteModel(
        uidCliente: _uidCliente,
        nome: _nomeController.text.trim(),
        telefone: toNumericString(_telefoneController.text.trim()),
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

      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cliente != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Paciente' : 'Cadastrar Paciente'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration(label: 'Nome', icon: Icons.person),
                validator: _validarNome,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _telefoneController,
                decoration: _inputDecoration(label: 'Telefone', icon: Icons.phone),
                keyboardType: TextInputType.phone,
                inputFormatters: [MaskedInputFormatter('(##) #####-####')],
                validator: _validarTelefone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: _inputDecoration(label: 'Data de Nascimento', icon: Icons.calendar_today),
                keyboardType: TextInputType.datetime,
                inputFormatters: [MaskedInputFormatter('##/##/####')],
                validator: _validarData,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _salvarCliente,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: theme.primaryColor,
                    elevation: 4,
                    shadowColor: theme.primaryColor.withAlpha(230),
                  ),
                  child: Text(
                    isEditing ? 'Salvar' : 'Cadastrar',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
