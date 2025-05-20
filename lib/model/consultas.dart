class ConsultaModel {
  String uidConsulta;
  String uidCliente;
  DateTime dataHora;
  String especialidade;
  String medico;

  ConsultaModel({
    required this.uidConsulta,
    required this.uidCliente,
    required this.dataHora,
    required this.especialidade,
    required this.medico,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidConsulta': uidConsulta,
      'uidCliente': uidCliente,
      'dataHora': dataHora.toIso8601String(),
      'especialidade': especialidade,
      'medico': medico,
    };
  }

  factory ConsultaModel.fromMap(Map<String, dynamic> map) {
    return ConsultaModel(
      uidConsulta: map['uidConsulta'],
      uidCliente: map['uidCliente'],
      dataHora: DateTime.parse(map['dataHora']),
      especialidade: map['especialidade'],
      medico: map['medico'],
    );
  }
}
