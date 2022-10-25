import 'package:angel_car/global/model/dependent.dart';

class AppUser {
  String? name;
  String? cellPhone;
  String? birthday;
  String? sex;
  String? email;
  String? holderDocument;
  String? holderUid;
  String? dependentDocument;
  String? dependentUid;
  bool? isHolder;
  bool? fullRegistration;
  String? status;
  String? pushId;
  int? conexaId;
  List<Dependent>? dependents;
  String? nextBill;
  String? planDuration;
  String? holderName;
  String? id;

  AppUser({
    this.name,
    this.cellPhone,
    this.birthday,
    this.sex,
    this.email,
    this.holderDocument,
    this.holderUid,
    this.dependentDocument,
    this.dependentUid,
    this.isHolder,
    this.fullRegistration,
    this.status,
    this.pushId,
    this.conexaId,
    this.dependents,
    this.nextBill,
    this.planDuration,
    this.holderName,
    this.id,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cellPhone = json['cell_phone'];
    birthday = json['birthday'];
    sex = json['sex'];
    email = json['email'];
    holderDocument =
        json['holder_document'];
    holderUid = json['holder_uuid'];
    dependentDocument =
        json['dependent_document'];
    dependentUid =
        json['dependent_uuid'];
    isHolder = json['is_holder'];
    fullRegistration =
        json['full_registration'];
    status = json['status'];
    pushId = json['push_id'];
    nextBill = json['next_bill'];
    planDuration = json['plan_duration'];
    holderName = json['holder_name'];
    id = json['id'];
    if (json['dependents'] != null) {
      dependents = [];
      json['dependents'].forEach((v) {
        dependents?.add(Dependent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['cell_phone'] = cellPhone;
    data['birthday'] = birthday;
    data['sex'] = sex;
    data['email'] = email;
    data['holder_document'] = holderDocument;
    data['holder_uuid'] = holderUid;
    data['dependent_document'] = dependentDocument;
    data['dependent_uuid'] = dependentUid;
    data['is_holder'] = isHolder;
    data['full_registration'] = fullRegistration;
    data['status'] = status;
    data['push_id'] = pushId;
    data['conexa_id'] = conexaId;
    data['next_bill'] = nextBill;
    data['plan_duration'] = planDuration;
    data['holder_name'] = holderName;
    data['id'] = id;
    if (dependents != null) {
      data['dependents'] = dependents?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
