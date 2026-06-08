import 'package:flutter/material.dart';

import '../auth/widgets/logout_button.dart';
import 'admin_orders_screen.dart';
import 'admin_section_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void openScreen(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      AdminDashboardItem(
        title: "Menu Management",
        icon: Icons.restaurant_menu,
        onTap: () => openScreen(
          context,
          const AdminSectionScreen(
            title: "Menu Management",
            icon: Icons.restaurant_menu,
          ),
        ),
      ),
      AdminDashboardItem(
        title: "Order Management",
        icon: Icons.receipt_long,
        onTap: () => openScreen(
          context,
          const AdminOrdersScreen(),
        ),
      ),
      AdminDashboardItem(
        title: "User Management",
        icon: Icons.people,
        onTap: () => openScreen(
          context,
          const AdminSectionScreen(
            title: "User Management",
            icon: Icons.people,
          ),
        ),
      ),
      AdminDashboardItem(
        title: "Role-Based Access",
        icon: Icons.admin_panel_settings,
        onTap: () => openScreen(
          context,
          const AdminSectionScreen(
            title: "Role-Based Access",
            icon: Icons.admin_panel_settings,
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final section = sections[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: section.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        section.icon,
                        size: 34,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              section.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
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
    );
  }
}

class AdminDashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AdminDashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
