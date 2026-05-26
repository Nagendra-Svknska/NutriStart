import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

import '../models/menu_item.dart';

class MenuService {

  Future<List<MenuItem>>
      getMenu() async {

    try {

      final response =
          await DioClient.dio.get(
        '/menu',
      );

      final data =
          List<dynamic>.from(
        response.data,
      );

      return data
          .map(
            (item) =>
                MenuItem.fromJson(item),
          )
          .toList();

    } on DioException catch (e) {

      print(e);

      return [];
    }
  }
}