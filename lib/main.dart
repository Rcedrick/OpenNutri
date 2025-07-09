import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_nutri/pages/profile_page.dart';
import 'package:open_nutri/pages/home_page.dart';
import 'package:open_nutri/pages/like_page.dart';
import 'package:open_nutri/pages/scan_page.dart';
import 'package:open_nutri/pages/splash_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:open_nutri/pages/authentification/signin_page.dart';
import 'package:open_nutri/pages/history_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenNutri',
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }



  final List<String> _titles = const [
    "Acceuil",
    "Favoris",
    "Scan",
    "Historique",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(onMenuTap: setCurrentIndex),
      LikePage(),
      ScanPage(),
      HistoryPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _titles[_currentIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png', // Assure-toi que ton chemin est correct
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Open Nutri",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],

      ),

      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: setCurrentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Accueil"),
            selectedColor: Colors.purple.shade700,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("Favoris"),
            selectedColor: Colors.purple.shade700,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.qr_code_scanner),
            title: const Text("Scan"),
            selectedColor: Colors.purple.shade700,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text("Historique"),
            selectedColor: Colors.purple.shade700,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.purple.shade700,
          ),
        ],
      ),
    );
  }
}

