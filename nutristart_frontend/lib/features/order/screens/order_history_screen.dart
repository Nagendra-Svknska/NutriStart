import 'package:flutter/material.dart';

import '../models/order_model.dart';

import '../services/order_service.dart';

class OrderHistoryScreen
    extends StatefulWidget {

  const OrderHistoryScreen({
    super.key,
  });

  @override
  State<OrderHistoryScreen>
      createState() =>
          _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  final orderService =
      OrderService();

  List<OrderModel> orders = [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadOrders();
  }

  Future<void> loadOrders() async {

    final result =
        await orderService
            .getOrders();

    setState(() {

      orders = result;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Order History"),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : orders.isEmpty

              ? const Center(
                  child: Text(
                    "No orders found",
                  ),
                )

              : ListView.builder(

                  itemCount:
                      orders.length,

                  itemBuilder:
                      (context, index) {

                    final order =
                        orders[index];

                    return Card(

                      margin:
                          const EdgeInsets
                              .all(12),

                      child: Padding(

                        padding:
                            const EdgeInsets
                                .all(16),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              "Order #${order.id}",

                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              "Status: ${order.status}",
                            ),

                            Text(
                              "Total: \$${order.total.toStringAsFixed(2)}",
                            ),

                            Text(
                              "Created: ${order.createdAt}",
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            const Text(

                              "Items",

                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            ...order.items.map(

                              (item) {

                                return Text(

                                  "${item['name']} x${item['quantity']}",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}