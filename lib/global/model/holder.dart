import 'package:angel_car/global/model/dependent.dart';

class Holder {
  String? name;
  int? id;
  int? customerId;
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
  String? nextBill;
  String? planDuration;
  String? authUid;
  List<Dependent?>? dependents;

  Holder(
      {this.name,
        this.id,
        this.customerId,
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
        this.nextBill,
        this.planDuration,
        this.authUid,
        this.dependents});

  Holder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    customerId = json['customer_id'];
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
    nextBill = json['next_bill'];
    planDuration = json['plan_duration'];
    authUid = json['auth_uid'];
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
    data['id'] = id;
    data['customer_id'] = customerId;
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
    data['next_bill'] = nextBill;
    data['plan_duration'] = planDuration;
    data['auth_uid'] = authUid;
    if (dependents != null) {
      data['dependents'] = dependents?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}