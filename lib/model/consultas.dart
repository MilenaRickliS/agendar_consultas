class OrderModel {
  String uidConsulta;
  String uidCliente;
  DateTime data;
  DateTime hora;
  List<Map<String, dynamic>> especialidade;
  List<Map<String, dynamic>> medico;

  OrderModel({
    required this.uidConsulta,
    required this.uidCliente,
    required this.data,
    required this.hora,
    required this.especialidade,
    required this.medico
  });

  Map<String, dynamic> toMap() {
    return {
      'uidPedido': uidConsulta,
      'uidCliente': uidCliente,
      'data': data,
      'hora': hora,
      'especialidade': especialidade,
      'medico': medico,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uidConsulta: map['uidConsulta'],
      uidCliente: map['uidCliente'],
      data: map['data'],
      hora: map['hora'],
      especialidade: List<Map<String, dynamic>>.from(map['especialidade']),
      medico: List<Map<String, dynamic>>.from(map['medico']),
    );
  }
}

// Clínica Geral, Pediatria, Ginecologia e Obstetrícia, Cardiologia, Ortopedia, Neurologia, Psiquiatria e Dermatologia