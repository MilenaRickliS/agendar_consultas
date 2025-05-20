import 'package:flutter/material.dart';
import 'package:agendar_consultas/model/consultas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultasProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ConsultaModel> _consultas = [];

  List<ConsultaModel> get consultas => _consultas;

 Future<void> carregarConsultas() async {
    final snapshot = await _db
        .collection('consultas')
        .orderBy('dataHora')
        .get();

    _consultas = snapshot.docs.map((doc) {
      final data = doc.data();
      try {
        return ConsultaModel.fromMap(data);
      } catch (e) {
        
        return null;
      }
    }).whereType<ConsultaModel>().toList();

    notifyListeners();
  }

  Future<void> agendarConsulta(ConsultaModel consulta) async {
    await _db.collection('consultas').doc(consulta.uidConsulta).set(consulta.toMap());
    await carregarConsultas();
  }

  Future<void> cancelarConsulta(String uidConsulta) async {
    await _db.collection('consultas').doc(uidConsulta).delete();
    await carregarConsultas();
  }
}
