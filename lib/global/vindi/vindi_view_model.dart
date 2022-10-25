import 'package:angel_car/global/model/bill.dart';
import 'package:angel_car/global/model/customer.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/model/subscription.dart';
import 'package:angel_car/global/vindi/response/bill_response.dart';
import 'package:angel_car/global/vindi/response/customer_response.dart';
import 'package:angel_car/global/vindi/response/subscription_response.dart';
import 'package:angel_car/global/vindi/vindi_repository.dart';

class VindiViewModel {
  static final _vindiRepository = VindiRepository();

  static Future<bool> clientActive({required String cpf}) async {
    var isClientActive = false;
    await _vindiRepository.getCustomer(cpf).then((value) {
      assert(value?.data != null);
      var customerResponse = CustomerResponse.fromJson(value?.data);
      assert(customerResponse.customers != null);
      if (customerResponse.customers!.isNotEmpty) {
        customerResponse.customers?.forEach((element) {
          if (element.status == 'active') {
            isClientActive = true;
          }
        });
      } else {
        isClientActive = false;
      }
    });
    return isClientActive;
  }

  static Future<int> customerId({required String cpf}) async {
    var id = 0;
    await _vindiRepository.getCustomer(cpf).then((value) {
      var customerResponse = CustomerResponse.fromJson(value?.data);
      assert(customerResponse.customers != null);
      if (customerResponse.customers!.isNotEmpty) {
        customerResponse.customers?.forEach((element) {
          if (element.status == 'active') {
            if (element.id != null) {
              id = element.id!;
            }
          }
        });
      } else {
        id = 0;
      }
    });
    return id;
  }

  static Future<int> planId({required customerId}) async {
    var id = 0;
    await _vindiRepository.getBills(customerId).then((value) {
      assert(value?.data != null);
      BillResponse billResponse = BillResponse.fromJson(value?.data);
      assert(billResponse.bills != null);
      if (billResponse.bills!.last.status == 'paid') {
        assert(billResponse.bills!.last.subscription != null);
        assert(billResponse.bills!.last.subscription!.plan != null);
        assert(billResponse.bills!.last.subscription!.plan!.id != null);
        id = billResponse.bills!.last.subscription!.plan!.id!;
      }
    });
    return id;
  }

  static Future<bool> planActive({required planId}) async {
    var isPlanActive = false;
    await _vindiRepository.getPlans(planId).then((value) {
      List list = value?.data['plans'];
      if (list.first['status'] == 'active') {
        isPlanActive = true;
      }
    });
    return isPlanActive;
  }

  static Future<bool> holderActive({required String cpf}) async {
    var isHolderActive = false;
    await customerId(cpf: cpf).then((customerId) async {
      if (customerId > 0) {
        await planId(customerId: customerId).then((planId) async {
          await planActive(planId: planId).then((value) {
            isHolderActive = true;
          });
        });
      } else {
        isHolderActive = false;
      }
    });
    return isHolderActive;
  }

  static Future<Holder?> getHolder({required String cpf}) async {
    List<Dependent>? dependents = [];
    Holder holder = Holder();
    await _vindiRepository.getCustomer(cpf).then((value) {
      var customerResponse = CustomerResponse.fromJson(value?.data);
      assert(customerResponse.customers != null);
      if (customerResponse.customers!.isNotEmpty) {
        customerResponse.customers?.forEach((element) {
          if (element.status == 'active') {
            holder.customerId = element.id;
            holder.name = element.name;
            holder.email = element.email;
            holder.document = "${element.registryCode!.substring(0, 3)}"
                ".${element.registryCode!.substring(3, 6)}"
                ".${element.registryCode!.substring(6, 9)}"
                "-${element.registryCode!.substring(9)}";
            if (element.phones != null) {
              element.phones?.forEach((phone) {
                if (phone.phoneType == "mobile" && phone.number != null) {
                  holder.cellphone = phone.number!;
                }
              });
            }
            if (element.metadata != null) {
              if (element.metadata?.nomeDependente != null &&
                  element.metadata!.nomeDependente!.isNotEmpty) {
                Dependent dependent = Dependent(
                    name: element.metadata?.nomeDependente,
                    sex: element.metadata?.sexoDependente01,
                    document: element.metadata?.cpfDependente,
                    dateBirthday: element.metadata?.nascimentoDependente);
                dependents.add(dependent);
              }

              if (element.metadata?.nomeDependente02 != null &&
                  element.metadata!.nomeDependente02!.isNotEmpty) {
                Dependent dependent2 = Dependent(
                    name: element.metadata?.nomeDependente02,
                    sex: element.metadata?.sexoDependente02,
                    document: element.metadata?.cpfDependente02,
                    dateBirthday: element.metadata?.nascimentoDependente02);
                dependents.add(dependent2);
              }

              if (element.metadata?.nomeDependente03 != null &&
                  element.metadata!.nomeDependente03!.isNotEmpty) {
                Dependent dependent3 = Dependent(
                    name: element.metadata?.nomeDependente03,
                    sex: element.metadata?.sexoDependente03,
                    document: element.metadata?.cpfDependente03,
                    dateBirthday: element.metadata?.nascimentoDependente03);
                dependents.add(dependent3);
              }

              if (element.metadata?.nomeDependente04 != null &&
                  element.metadata!.nomeDependente04!.isNotEmpty) {
                Dependent dependent4 = Dependent(
                    name: element.metadata?.nomeDependente04,
                    sex: element.metadata?.sexoDependente04,
                    document: element.metadata?.cpfDependente04,
                    dateBirthday: element.metadata?.nascimentoDependente04);
                dependents.add(dependent4);
              }

              if (element.metadata?.nomeDependente05 != null &&
                  element.metadata!.nomeDependente05!.isNotEmpty) {
                Dependent dependent5 = Dependent(
                    name: element.metadata?.nomeDependente05,
                    sex: element.metadata?.sexoDependente05,
                    document: element.metadata?.cpfDependente05,
                    dateBirthday: element.metadata?.nascimentoDependente05);
                dependents.add(dependent5);
              }
              holder.dependents = dependents;
            }
          }
        });
      }
    });
    return holder;
  }

  static Future<String> getPlanName({required customerId}) async {
    var planName = '';
    await _vindiRepository.getBills(customerId).then((value) {
      assert(value?.data != null);
      BillResponse billResponse = BillResponse.fromJson(value?.data);
      assert(billResponse.bills != null);
      billResponse.bills?.forEach((element) {
        if (element.status == 'paid') {
          assert(element.subscription != null);
          assert(element.subscription?.plan != null);
          assert(element.subscription?.plan?.name != null);
          planName = element.subscription!.plan!.name!;
        }
      });
    });
    return planName;
  }

  static Future<Customer?> getCustomer({required String? cpf}) async {
    Customer customer = Customer();
    await _vindiRepository.getCustomer(cpf).then((value) {
      var customerResponse = CustomerResponse.fromJson(value?.data);
      assert(customerResponse.customers != null);
      if (customerResponse.customers!.isNotEmpty) {
        customerResponse.customers?.forEach((element) async {
          if (element.status == 'active') {
            customer = element;
          }
        });
      }
    });

    return customer;
  }

  static Future<Bill?> getBill({required int? customerId}) async {
    Bill bill = Bill();
    await _vindiRepository.getBills(customerId).then((value) async {
      BillResponse billResponse = BillResponse.fromJson(value?.data);
      billResponse.bills?.forEach((element) {
        if (element.status == 'paid') {
          bill = element;
        }
      });
    });
    return bill;
  }

  static Future<Subscription> getSubscription(
      {required int? customerId}) async {
    Subscription subscription = Subscription();
    await _vindiRepository.getSubscriptions(customerId).then((value) {
      SubscriptionResponse subscriptionResponse =
          SubscriptionResponse.fromJson(value?.data);
      subscriptionResponse.subscriptions?.forEach((element) {
        if (element.status == 'active') {
          subscription = element;
        }
      });
    });
    return subscription;
  }

  static Future<bool> isHolder({required String cpf}) async {
    var isHolder = false;
    await _vindiRepository.getCustomer(cpf).then((value) {
      var customerResponse = CustomerResponse.fromJson(value?.data);
      assert(customerResponse.customers != null);
      if (customerResponse.customers!.isNotEmpty) {
        customerResponse.customers?.forEach((element) {
          if (element.status == 'active') {
            if(element.registryCode == cpf){
              isHolder = true;
            }
          }
        });
      }
    });
    return isHolder;
  }
}
