import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
// import '../../features/auth/services/';
import '../storage/token_storage.dart';

class DioClient {

static final Dio dio = Dio(
  BaseOptions(

    // web browser uses
    // baseUrl: 'http://127.0.0.1:8000',

    // android emulator uses
    // baseUrl: 'http://10.0.2.2:8000',

    // baseUrl: 'http://127.0.0.1:8000',

    //deployed to railway
    // baseUrl: 'https://nutristart-production.up.railway.app/',

    baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000',
    
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {'Content-Type': 'application/json',},),)
  
  ..interceptors.add(

    InterceptorsWrapper(

      onRequest:

          (options, handler) async {

        final token =await TokenStorage.getToken();
        // final token = null;

        if (token != null) {
          print("TOKEN SENT latest: $token");

          options.headers[
              'Authorization'] =

              'Bearer $token';
        }

        return handler.next(
          options,
        );
      },
    ),
  );
  void logBaseUrl() {
    print("BASE URL: http://10.0.2.2:8000");
  }
}