import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';

import '../../order/screens/final_screen.dart';
import '../../order/services/order_service.dart';

class CartScreen extends ConsumerWidget {

  const CartScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final cart =
        ref.watch(cartProvider);

    final totalPrice =
        cart.fold(

      0.0,

      (sum, cartItem) =>

          sum +

          (cartItem.item.price *
              cartItem.quantity),
    );

    final orderService =
        OrderService();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Your Cart"),
      ),

      body: cart.isEmpty

          ? const Center(

              child: Text(
                "Cart is empty",
              ),
            )

          : Column(

              children: [

                Expanded(

                  child: ListView.builder(

                    itemCount: cart.length,

                    itemBuilder:
                        (context, index) {

                      final cartItem =
                          cart[index];

                      return Card(

                        margin:
                            const EdgeInsets.all(
                          12,
                        ),

                        child: ListTile(

                          leading: SizedBox(

                            width: 60,
                            height: 60,

                            child: Image.network(

                              cartItem.item.image ??
                                  '',

                              fit: BoxFit.cover,

                              errorBuilder:
                                  (_, __, ___) {

                                return const Icon(
                                  Icons.image,
                                );
                              },
                            ),
                          ),

                          title: Text(
                            cartItem.item.name,
                          ),

                          subtitle: Text(
                            "Qty: ${cartItem.quantity}",
                          ),

                          trailing: SizedBox(

                            width: 170,

                            child: Column(

                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                Text(

                                  "\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}",
                                ),

                                const SizedBox(
                                  height: 6,
                                ),

                                Row(

                                  mainAxisSize:
                                      MainAxisSize.min,

                                  children: [

                                    IconButton(

                                      onPressed: () {

                                        if (cartItem
                                                .quantity >
                                            1) {

                                          cartItem
                                              .quantity--;

                                        } else {

                                          cart.removeAt(
                                            index,
                                          );
                                        }

                                        ref
                                            .read(
                                              cartProvider
                                                  .notifier,
                                            )
                                            .state = [
                                          ...cart
                                        ];
                                      },

                                      icon: const Icon(
                                        Icons.remove,
                                      ),
                                    ),

                                    IconButton(

                                      onPressed: () {

                                        cartItem
                                            .quantity++;

                                        ref
                                            .read(
                                              cartProvider
                                                  .notifier,
                                            )
                                            .state = [
                                          ...cart
                                        ];
                                      },

                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),

                                    IconButton(

                                      onPressed: () {

                                        cart.removeAt(
                                          index,
                                        );

                                        ref
                                            .read(
                                              cartProvider
                                                  .notifier,
                                            )
                                            .state = [
                                          ...cart
                                        ];
                                      },

                                      icon: const Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(

                  padding:
                      const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

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

                      const SizedBox(height: 20),

                      SizedBox(

                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(

                          onPressed: () async {

                            final orderItems =
                                [...cart];

                            final success =
                                await orderService
                                    .placeOrder(
                              cart,
                            );

                            if (success) {

                              ref
                                  .read(
                                    cartProvider
                                        .notifier,
                                  )
                                  .state = [];
                            }

                            Navigator.pushReplacement(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    FinalScreen(

                                  cart: orderItems,

                                  success: success,
                                ),
                              ),
                            );
                          },

                          child: const Text(
                            "Place Order",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}