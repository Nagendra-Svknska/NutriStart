import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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

      await TokenStorage.saveToken(token);

      print("TOKEN SAVED");
      
      final savedToken =await TokenStorage.getToken();
      print(savedToken);

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

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

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

                onPressed: isLoading
                    ? null
                    : login,

                child: isLoading

                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                    : const Text(
                        "Login",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}