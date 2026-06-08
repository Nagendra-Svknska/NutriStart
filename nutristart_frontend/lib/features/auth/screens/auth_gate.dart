import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../admin/admin_dashboard_screen.dart';
import '../../menu/menu_screen.dart';
import '../../menu/services/menu_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {

  const AuthGate({super.key});

  @override
  State<AuthGate> createState() =>
      _AuthGateState();
}

class _AuthGateState
    extends State<AuthGate> {

  final MenuService menuService =
      MenuService();

  @override
  void initState() {
    super.initState();

    checkAuth();
  }

  Future<void> checkAuth() async {

    final token =
        await TokenStorage.getToken();
    final role =
        await TokenStorage.getUserRole();

    print("TOKEN: $token");

    if (token != null) {

      if (role == "ADMIN") {

        if (!mounted) return;

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const AdminDashboardScreen(),
          ),
        );

        return;
      }

      final menuItems =
          await menuService.getMenu();

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) => MenuScreen(
            menuItems: menuItems,
          ),
        ),
      );

    } else {

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: CircularProgressIndicator(),
      ),
    );
  }
}
