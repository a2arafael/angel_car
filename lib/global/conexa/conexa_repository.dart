import 'package:dio/dio.dart';
import 'package:angel_car/global/conexa/request/user_registration_request.dart';
import 'package:angel_car/global/utils/app-strings.dart';

class ConexaRepository {
  final _dio = Dio();

  ConexaRepository() {
    _dio.options.baseUrl = AppStrings.conexaBaseUrl;
    _dio.options.headers = {
      'token': AppStrings.conexaToken,
      'Content-Type': AppStrings.conexaContentType
    };
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
  }

  Future<Response> createOrUpdatePatient(UserRegistrationRequest request) {
    return _dio.post(
      '/family-group',
      data: request.toJson(),
    );
  }

  Future<Response> activatePatient(int? id) {
    return _dio.get(
      '/patients/$id/activate',
    );
  }

  Future<Response> inactivatePatient(int? id) {
    return _dio.get(
      '/patients/$id/inactivate',
    );
  }

  Future<Response> blockPatient(int? id) {
    return _dio.get(
      '/patients/$id/block',
    );
  }

  Future<Response> unblockPatient(int? id) {
    return _dio.get(
      '/patients/$id/unblock',
    );
  }

  Future<Response> generateMagicLink(int? id) {
    return _dio.get(
      '/patients/generate-magiclink-access-app/$id',
    );
  }

  Future<Response> acceptTermsPatient(int? id, String ip) {
    return _dio.post(
      '/patients/accept/term',
      data: {"idPatient": id, "ip": ip},
    );
  }
}
