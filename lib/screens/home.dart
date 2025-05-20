import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/clientes_provider.dart';
import '../provider/consultas_provider.dart';
import 'package:agendar_consultas/screens/detalhes.dart';
import 'package:agendar_consultas/screens/cadastrar.dart';
import 'package:agendar_consultas/screens/agendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}