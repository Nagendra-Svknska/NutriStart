import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';

import '../screens/login_screen.dart';

class LogoutButton extends StatelessWidget {

  const LogoutButton({super.key});

  Future<void> logout(
    BuildContext context,
  ) async {

    await TokenStorage.clearToken();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const LoginScreen(),
      ),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return IconButton(

      onPressed: () => logout(context),

      icon: const Icon(Icons.logout),
    );
  }
}