import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../cart/models/cart_item.dart';
import '../models/order_model.dart';

class OrderService {

  Future<bool> placeOrder(

    List<CartItem> cart,
  ) async {

    try {

      final total = cart.fold(

        0.0,

        (sum, cartItem) =>

            sum +

            (cartItem.item.price *
                cartItem.quantity),
      );

      final items = cart.map((cartItem) {

        return {

          "name":
              cartItem.item.name,

          "quantity":
              cartItem.quantity,

          "price":
              cartItem.item.price,
        };

      }).toList();

      final response =
          await DioClient.dio.post(

        "/orders",

        data: {

          "items": items,

          "total": total,
        },
      );

      print(response.data);

      return true;

    } on DioException catch (e) {

      print(e.response?.data);

      return false;
    }
  }

Future<List<OrderModel>>
    getOrders() async {

  try {

    final response =
        await DioClient.dio.get(
      "/orders",
    );

    final data =
        response.data as List;

    return data.map((json) {

      return OrderModel.fromJson(
        json,
      );

    }).toList();

  } on DioException {

    return [];
  }
}


}