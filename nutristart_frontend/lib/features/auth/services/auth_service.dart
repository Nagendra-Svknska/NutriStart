import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class AuthService {

  Future<String> getWelcomeMessage() async {

    try {
      print("Inside AuthService");
      final response = await DioClient.dio.get('/');
      print("Inside AuthService: ${response.data['message']}");

      return response.data['message'];

    } on DioException catch (e) {

      return "API Error: ${e.message}";
    }
  }

  Future<Map<String, dynamic>> login({

    required String email,
    required String password,

  }) async {

    try {

      final response = await DioClient.dio.post(

        '/login',

        data: {
          'email': email,
          'password': password,
        },
      );
      print(response.data);
      return response.data;

    } on DioException catch (e) {

      return {
        "error": e.message
      };
    }
  }

}