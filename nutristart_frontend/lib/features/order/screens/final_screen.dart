import 'package:flutter/material.dart';
import '../../cart/models/cart_item.dart';
import '../screens/order_history_screen.dart';

class FinalScreen extends StatelessWidget {

  final List<CartItem> cart;

  final bool success;

  const FinalScreen({

    super.key,

    required this.cart,

    required this.success,
  });

  @override
  Widget build(BuildContext context) {

    final totalPrice =
        cart.fold(

      0.0,

      (sum, cartItem) =>

          sum +

          (cartItem.item.price *
              cartItem.quantity),
    );

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Order Summary",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Center(

              child: Column(

                children: [

                  Icon(

                    success
                        ? Icons.check_circle
                        : Icons.cancel,

                    color: success
                        ? Colors.green
                        : Colors.red,

                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  Text(

                    success
                        ? "Order Placed Successfully"
                        : "Order Failed",

                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Order Items",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: ListView.builder(

                itemCount: cart.length,

                itemBuilder:
                    (context, index) {

                  final cartItem =
                      cart[index];

                  return ListTile(

                    title: Text(
                      cartItem.item.name,
                    ),

                    subtitle: Text(
                      "Qty: ${cartItem.quantity}",
                    ),

                    trailing: Text(

                      "\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}",
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                const Text(

                  "Total",

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(

                  "\$${totalPrice.toStringAsFixed(2)}",

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
        const SizedBox(
            height: 30,
          ),

          SizedBox(

            width: double.infinity,
            height: 55,

            child: ElevatedButton(

              onPressed: () {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const OrderHistoryScreen(),
                  ),
                );
              },

              child: const Text(
                "View Orders",
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}