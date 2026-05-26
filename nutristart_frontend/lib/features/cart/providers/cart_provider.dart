import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';

final cartProvider = StateProvider<
    List<CartItem>>((ref) {

  return [];
});