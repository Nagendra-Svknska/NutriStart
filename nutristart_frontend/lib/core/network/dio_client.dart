import 'package:dio/dio.dart';

class DioClient {

  static final Dio dio = Dio(

    BaseOptions(
      
      // web browser uses
      // baseUrl: 'http://127.0.0.1:8000',

      // android emulator uses
      // baseUrl: 'http://10.0.2.2:8000',

      baseUrl: 'http://127.0.0.1:8000',

      

      connectTimeout: const Duration(seconds: 5),

      receiveTimeout: const Duration(seconds: 5),

      headers: {
        'Content-Type': 'application/json',
      },
    ),
    
  );
  void logBaseUrl() {
    print("BASE URL: http://10.0.2.2:8000");
  }
}