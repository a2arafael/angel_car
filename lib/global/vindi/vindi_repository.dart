import 'package:dio/dio.dart';
import 'package:angel_car/global/utils/app-strings.dart';

class VindiRepository {
  final _dio = Dio();

  VindiRepository() {
    _dio.options.baseUrl = AppStrings.vindiBaseUrl;
    _dio.options.headers = {
      'accept': AppStrings.vindiAccept,
      'authorization': AppStrings.vindiAuthorization
    };
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 5000;
  }

  Future<Response?> getCustomer(String? cpf) async {
    try {
      return await _dio.get("/customers?query=registry_code:$cpf");
    } on Exception catch (e) {
      print("****** Catch getCustomer: $e");
      return null;
    }
  }

  Future<Response?> getBills(int? customerId) async {
    try {
      return await _dio.get("/bills?query=customer_id:$customerId");
    } on Exception catch (e) {
      print("****** Catch getBills: $e");
      return null;
    }
  }

  Future<Response?> getSubscriptions(int? customerId) async {
    try {
      return await _dio.get("/subscriptions?query=customer_id:$customerId");
    } on Exception catch (e) {
      print("****** Catch getSubscriptions: $e");
      return null;
    }
  }

  Future<Response?> getPlans(int? planId) async {
    try {
      return await _dio.get("/plans?query=id:$planId");
    } on Exception catch (e) {
      print("****** Catch getPlans: $e");
      return null;
    }
  }
}
