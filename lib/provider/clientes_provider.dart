import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agendar_consultas/model/clientes.dart';

class ClientesProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ClienteModel> _clientes = [];
  List<ClienteModel> get clientes => _clientes;

  Future<void> carregarClientes() async {
    final snapshot = await _db.collection('clientes').get();
    _clientes = snapshot.docs.map((doc) {
      final data = doc.data();
      return ClienteModel(
        uidCliente: doc.id,
        nome: data['nome'],
        dataNascimento: data['dataNascimento'],
        telefone: data['telefone'],
      );
    }).toList();
    notifyListeners();
  }


  Future<void> cadastrarCliente(ClienteModel cliente) async {
    await _db.collection('clientes').doc(cliente.uidCliente).set(cliente.toMap());
    await carregarClientes();
  }

  Future<void> atualizarCliente(ClienteModel cliente) async {
    await _db.collection('clientes').doc(cliente.uidCliente).update(cliente.toMap());
    await carregarClientes();
  }

  Future<void> excluirCliente(String uid) async {
    await _db.collection('clientes').doc(uid).delete();
    await carregarClientes();
  }
}