import 'package:flutter/material.dart';
import 'package:agendar_consultas/provider/clientes_provider.dart';
import 'package:provider/provider.dart';
import 'package:agendar_consultas/screens/cadastrar.dart';
import 'package:agendar_consultas/model/clientes.dart';

class VisualizarClientesScreen extends StatefulWidget {
  const VisualizarClientesScreen({super.key});

  @override
  State<VisualizarClientesScreen> createState() => _VisualizarClientesScreenState();
}

class _VisualizarClientesScreenState extends State<VisualizarClientesScreen> {
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    setState(() {
      _carregando = true;
    });
    await Provider.of<ClientesProvider>(context, listen: false).carregarClientes();
    setState(() {
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro({ClienteModel? cliente}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastrarScreen(cliente: cliente),
      ),
    );
    await _carregarClientes(); // Recarrega após voltar
  }

  Future<void> _confirmarExclusao(String uidCliente) async {
    final clientesProvider = Provider.of<ClientesProvider>(context, listen: false);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Cliente'),
        content: const Text('Deseja realmente excluir este cliente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmar == true) {
      await clientesProvider.excluirCliente(uidCliente);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente excluído')));
      await _carregarClientes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirCadastro(),
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : clientesProvider.clientes.isEmpty
              ? const Center(child: Text('Nenhum cliente cadastrado.'))
              : ListView.builder(
                  itemCount: clientesProvider.clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientesProvider.clientes[index];
                    return ListTile(
                      title: Text(cliente.nome),
                      subtitle: Text('Telefone: ${cliente.telefone}\nNascimento: ${cliente.dataNascimento}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _abrirCadastro(cliente: cliente),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarExclusao(cliente.uidCliente),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
