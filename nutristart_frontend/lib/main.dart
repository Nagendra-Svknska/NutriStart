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

  Widget offeringCard(IconData icon,String title,) 
  {
    return Container(
      width: 220,
      height: 150,

      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10,color: Colors.black12,)],),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 50,
            color: Colors.green,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  // LOGO
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                    },

                    child: Row(
                      children: const [

                        Icon(
                          Icons.restaurant,
                          color: Colors.green,
                          size: 36,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "NutriStart",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LOGIN BUTTON
                  ElevatedButton.icon(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AuthGate(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.login),

                    label: const Text(
                      "Login",
                    ),
                  ),
                ],
              ),
            ),

            // HERO SECTION
            Container(
              height: 350,
              width: double.infinity,

              margin: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),

                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1547592180-85f173990554",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Healthy Meals Delivered Smarter",
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),

              child: Text(
                "Fresh meals, nutrition focused plans and convenient delivery.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // OFFERINGS
            const Text(
              "Our Offerings",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,

              children: [

                offeringCard(
                  Icons.restaurant_menu,
                  "Healthy Meals",
                ),

                offeringCard(
                  Icons.fitness_center,
                  "Fitness Nutrition",
                ),

                offeringCard(
                  Icons.local_shipping,
                  "Fast Delivery",
                ),

                offeringCard(
                  Icons.calendar_month,
                  "Meal Plans",
                ),
              ],
            ),

            const SizedBox(height: 60),

            // FOOTER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.black87,

              child: const Column(
                children: [

                  Text(
                    "NutriStart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Visakhapatnam, Andhra Pradesh",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "+91 XXXXX XXXXX",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "support@nutristart.com",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
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