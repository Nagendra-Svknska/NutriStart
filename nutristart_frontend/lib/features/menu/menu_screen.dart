import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/widgets/logout_button.dart';

import 'models/menu_item.dart';

import '../cart/providers/cart_provider.dart';
import '../cart/models/cart_item.dart';
import '../cart/screens/cart_screen.dart';

class MenuScreen extends ConsumerWidget {

  final List<MenuItem> menuItems;

  const MenuScreen({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final cart =
        ref.watch(cartProvider);

    final totalCartItems =
        cart.fold(

      0,

      (sum, cartItem) =>
          sum + cartItem.quantity,
    );

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Menu ($totalCartItems)",
        ),

        actions: [

          IconButton(

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const CartScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),

          const LogoutButton(),
        ],
      ),

      body: ListView.builder(

        itemCount: menuItems.length,

        itemBuilder: (context, index) {

          final item = menuItems[index];

          return Card(

            margin: const EdgeInsets.all(12),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                ClipRRect(

                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),

                  child: Image.network(

                    item.image ?? '',

                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    errorBuilder:
                        (_, __, ___) {

                      return Container(

                        height: 200,

                        color:
                            Colors.grey.shade300,

                        child: const Center(

                          child:
                              Icon(Icons.image),
                        ),
                      );
                    },
                  ),
                ),

                Padding(

                  padding:
                      const EdgeInsets.all(16),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(

                            item.name,

                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            "Quantity: ${item.quantity}",
                          ),
                        ],
                      ),

                      Row(

                        children: [

                          Text(

                            "\$${item.price.toStringAsFixed(2)}",

                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          ElevatedButton(

                            onPressed: () {

                              final cart =
                                  ref.read(
                                cartProvider,
                              );

                              final existingIndex =
                                  cart.indexWhere(

                                (cartItem) =>

                                    cartItem
                                        .item
                                        .id ==

                                    item.id,
                              );

                              if (existingIndex !=
                                  -1) {

                                cart[
                                        existingIndex]
                                    .quantity++;

                                ref
                                    .read(
                                      cartProvider
                                          .notifier,
                                    )
                                    .state = [
                                  ...cart
                                ];

                              } else {

                                ref
                                    .read(
                                      cartProvider
                                          .notifier,
                                    )
                                    .state = [

                                  ...cart,

                                  CartItem(
                                    item: item,
                                    quantity: 1,
                                  ),
                                ];
                              }

                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(

                                SnackBar(

                                  content: Text(
                                    "${item.name} added to cart",
                                  ),
                                ),
                              );
                            },

                            child: const Text(
                              "Add",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}