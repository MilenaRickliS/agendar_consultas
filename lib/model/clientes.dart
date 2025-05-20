class ClienteModel {
  String uidCliente;
  String nome;
  String dataNascimento;
  String telefone;

  ClienteModel({
    required this.uidCliente,
    required this.nome,
    required this.dataNascimento,
    required this.telefone,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      uidCliente: map['uidCliente'],
      nome: map['nome'],
      dataNascimento: map['dataNascimento'],
      telefone: map['telefone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uidCliente': uidCliente,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
    };
  }
}