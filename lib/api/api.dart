import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIRepository {
  late Dio _client;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  APIRepository() {
    _client = Dio()
      ..options.baseUrl = 'https://test.profcleaning.kz/api'
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions option,
            RequestInterceptorHandler interceptorHandler) async {
          // _storage.deleteAll();
          String? token = await _storage.read(key: "accessToken");
          option.headers.addAll({
            "Authorization": "Bearer $token",
            // "Accept": "application/json",
          });

          return interceptorHandler.next(option);
        }, onError: (DioError error, ErrorInterceptorHandler handler) {
          print(error);
        }),
      );
  }
  Future<Response> logIn({String? username, String? password}) async {
    return await Dio().post(
      'https://test.profcleaning.kz/api/v1/login',
      data: {
        "username": username,
        "password": password,
      },
    );
  }

  Future<Response> signUp({
    String? email,
    String? password,
    String? name,
    String? surname,
    String? username,
  }) async {
    return await Dio()
        .post('https://test.profcleaning.kz/api/v1/registration', data: {
      "email": email,
      "password": password,
      "username": username,
      'surname': surname,
      'name': name,
    });
  }

  Future<Response> fetchProfile() async {
    return await _client.get('/v1/user');
  }

  Future<Response> addHouse() async {
    return await _client.get('/v1/houses');
  }
}
