import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/consultas_provider.dart';
import 'package:agendar_consultas/screens/detalhes.dart';
import 'package:agendar_consultas/widget/menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConsultasProvider>(context, listen: false).carregarConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final consultasProvider = Provider.of<ConsultasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas Agendadas'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  icon: Icons.person_add,
                  label: 'Novo Paciente',
                  onTap: () => Navigator.pushNamed(context, '/cadastrar'),
                ),
                MenuButton(
                  icon: Icons.calendar_today,
                  label: 'Agendar',
                  onTap: () => Navigator.pushNamed(context, '/agendar'),
                ),
                MenuButton(
                  icon: Icons.people,
                  label: 'Pacientes',
                  onTap: () => Navigator.pushNamed(context, '/pacientes'),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: consultasProvider.consultas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma consulta agendada.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: consultasProvider.consultas.length,
                    itemBuilder: (context, index) {
                      final consulta = consultasProvider.consultas[index];
                      return Dismissible(
                        key: Key(consulta.uidConsulta),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red.shade700,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white, size: 32),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancelar Consulta'),
                              content: const Text('Deseja realmente cancelar esta consulta?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Não'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Sim'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          await Provider.of<ConsultasProvider>(context, listen: false)
                              .cancelarConsulta(consulta.uidConsulta);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Consulta cancelada')),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            title: Text(
                              'Consulta ID: ${consulta.uidConsulta}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal,
                              ),
                            ),
                            subtitle: Text(
                              'Data: ${consulta.dataHora.day.toString().padLeft(2, '0')}/'
                              '${consulta.dataHora.month.toString().padLeft(2, '0')}/'
                              '${consulta.dataHora.year} às '
                              '${consulta.dataHora.hour.toString().padLeft(2, '0')}:'
                              '${consulta.dataHora.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesScreen(consulta: consulta),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
