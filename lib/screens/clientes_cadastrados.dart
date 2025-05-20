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
    await _carregarClientes();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente excluído')),
      );
      await _carregarClientes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirCadastro(),
        backgroundColor: theme.primaryColor,
        elevation: 6,
        child: const Icon(Icons.add, size: 28),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : clientesProvider.clientes.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum cliente cadastrado.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: clientesProvider.clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientesProvider.clientes[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            cliente.nome,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Telefone: (${cliente.telefone.substring(0,2)}) ${cliente.telefone.substring(2,7)}-${cliente.telefone.substring(7,11)}\nNascimento: ${cliente.dataNascimento}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ),
                          trailing: SizedBox(
                            width: 96,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Botão editar
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () => _abrirCadastro(cliente: cliente),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.orange, size: 22),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Botão excluir
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () => _confirmarExclusao(cliente.uidCliente),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.red, size: 22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
