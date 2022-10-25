class HolderResponse {
  int? id;
  String? name;
  String? mail;
  String? dateBirth;
  String? sex;
  String? cpf;
  String? cellphone;

  HolderResponse({
    this.id,
    this.name,
    this.mail,
    this.dateBirth,
    this.sex,
    this.cpf,
    this.cellphone,
  });

  HolderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mail = json['mail'];
    dateBirth = json['dateBirth'];
    sex = json['sex'];
    cpf = json['cpf'];
    cellphone = json['cellphone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mail'] = mail;
    data['dateBirth'] = dateBirth;
    data['sex'] = sex;
    data['cpf'] = cpf;
    data['cellphone'] = cellphone;
    return data;
  }
}
