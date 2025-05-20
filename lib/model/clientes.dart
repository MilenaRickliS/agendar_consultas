class ClienteModel {
  String uid;
  String nome;
  String dataNascimento;
  String telefone;

  ClienteModel({
    required this.uid,
    required this.nome,
    required this.dataNascimento,
    required this.telefone,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      uid: map['uid'],
      nome: map['nome'],
      dataNascimento: map['dataNascimento'],
      telefone: map['telefone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
    };
  }
}