import 'package:flutter/material.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/screens/auth_gate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp(),),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),

      // home: Scaffold(body: Center(child: Text("Test"),),),
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

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    print("HOME PAGE INIT");

    fetchMessage();
  }

  Future<void> fetchMessage() async {

    final result = await authService.getWelcomeMessage();
    print("RESULT = $result");
    setState(() {message = result;});
    
    // setState(() {message = "Skipping API";});

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

                      builder: (_) =>
                          const AuthGate(),
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

class LoggedInScreen
    extends StatelessWidget {

  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("NutriStart"),
      ),

      body: const Center(

        child: Text(
          "User already logged in ✅",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}