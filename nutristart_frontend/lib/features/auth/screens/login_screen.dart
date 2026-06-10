import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../../admin/admin_dashboard_screen.dart';
import '../../menu/menu_screen.dart';
import '../../menu/services/menu_service.dart';
import '../../../core/storage/token_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  final AuthService authService = AuthService();
  final MenuService menuService = MenuService();

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final result = await authService.login(

      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result["access_token"] != null) {

      final token = result["access_token"];
      final role =
          (result["role"] as String?) ?? "user";

      await TokenStorage.saveToken(token);
      await TokenStorage.saveUserRole(role);

      print("TOKEN SAVED");
      
      final savedToken =await TokenStorage.getToken();
      print(savedToken);

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

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) => MenuScreen(
            menuItems: menuItems,
          ),
        ),
      );

  } 
  else 
  {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            result["error"] ?? "Login Failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

    body: Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.green,
                ),

                const SizedBox(height: 16),

                const Text(
                  "NutriStart",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : login,

                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                ),

                const SizedBox(height: 50),

                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "📍 Visakhapatnam, Andhra Pradesh",
                ),

                const SizedBox(height: 8),

                const Text(
                  "📞 +91 XXXXX XXXXX",
                ),

                const SizedBox(height: 8),

                const Text(
                  "✉️ support@nutristart.com",
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
