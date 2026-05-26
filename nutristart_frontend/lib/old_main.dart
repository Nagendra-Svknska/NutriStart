import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "Loading...";

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    try {
      final response = await dio.get(
        'http://127.0.0.1:8000',
      );

      setState(() {
        message = response.data['message'];
      });

    } catch (e) {
      setState(() {
        message = "Error connecting API";
      });

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: [

      Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 40),

      ElevatedButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );

        },

        child: const Text("Go To Login"),
      ),
    ],
  ),
),
    );
  }
}