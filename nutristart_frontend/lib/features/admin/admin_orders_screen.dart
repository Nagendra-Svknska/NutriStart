import 'package:flutter/material.dart';

import '../auth/widgets/logout_button.dart';
import '../order/models/order_model.dart';
import '../order/services/order_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() =>
      _AdminOrdersScreenState();
}

class _AdminOrdersScreenState
    extends State<AdminOrdersScreen> {
  final orderService = OrderService();

  List<OrderModel> orders = [];
  bool isLoading = true;
  int? updatingOrderId;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final result =
        await orderService.getAdminOrders();

    if (!mounted) return;

    setState(() {
      orders = result;
      isLoading = false;
    });
  }

  Future<void> updateStatus(
    OrderModel order,
    String status,
  ) async {
    setState(() {
      updatingOrderId = order.id;
    });

    final success =
        await orderService.updateOrderStatus(
      order.id,
      status,
    );

    if (!mounted) return;

    setState(() {
      updatingOrderId = null;
    });

    if (success) {
      await loadOrders();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Order updated"
              : "Could not update order",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Orders"),
        actions: const [
          LogoutButton(),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadOrders,
              child: orders.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 240),
                        Center(
                          child: Text("No orders found"),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final isUpdating =
                            updatingOrderId ==
                                order.id;

                        return Card(
                          margin:
                              const EdgeInsets.all(12),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
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
                                    Text(
                                      order.status,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total: \$${order.total.toStringAsFixed(2)}",
                                ),
                                Text(
                                  "Created: ${order.createdAt}",
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Items",
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...order.items.map((item) {
                                  return Text(
                                    "${item['name']} x${item['quantity']}",
                                  );
                                }),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            isUpdating
                                                ? null
                                                : () =>
                                                    updateStatus(
                                                      order,
                                                      "ACCEPTED",
                                                    ),
                                        child: const Text(
                                          "Accept",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 12),
                                    Expanded(
                                      child:
                                          OutlinedButton(
                                        onPressed:
                                            isUpdating
                                                ? null
                                                : () =>
                                                    updateStatus(
                                                      order,
                                                      "REJECTED",
                                                    ),
                                        child: const Text(
                                          "Reject",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
