class Dependent {
  String? name;
  int? id;
  String? email;
  String? document;
  String? cellphone;
  String? dateBirthday;
  String? sex;
  String? pushId;
  int? conexaId;
  bool? fullRegistration;
  bool? isHolder;
  String? status;
  String? authUid;
  String? holderDocument;

  Dependent({this.name,
    this.id,
    this.email,
    this.document,
    this.cellphone,
    this.dateBirthday,
    this.sex,
    this.pushId,
    this.conexaId,
    this.fullRegistration,
    this.isHolder,
    this.status,
    this.authUid,
    this.holderDocument});

  Dependent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    document = json['document'];
    cellphone = json['cellphone'];
    dateBirthday = json['date_birthday'];
    sex = json['sex'];
    pushId = json['push_id'];
    conexaId = json['conexa_id'];
    fullRegistration = json['full_registration'];
    isHolder = json['is_holder'];
    status = json['status'];
    authUid = json['auth_uid'];
    holderDocument = json['holder_document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['document'] = document;
    data['cellphone'] = cellphone;
    data['date_birthday'] = dateBirthday;
    data['sex'] = sex;
    data['push_id'] = pushId;
    data['conexa_id'] = conexaId;
    data['full_registration'] = fullRegistration;
    data['is_holder'] = isHolder;
    data['status'] = status;
    data['auth_uid'] = authUid;
    data['holder_document'] = holderDocument;
    return data;
  }
}
