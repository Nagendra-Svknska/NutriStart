import '../../menu/models/menu_item.dart';

class CartItem {

  final MenuItem item;

  int quantity;

  CartItem({

    required this.item,
    required this.quantity,
  });
}