import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_nutri/pages/info_page.dart';
import 'package:open_nutri/pages/product_detail_page.dart';
import 'package:open_nutri/pages/scanner_page.dart';
import 'package:open_nutri/services/product_service.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:open_nutri/pages/authentification/signin_page.dart';
import 'package:open_nutri/pages/home_page.dart';
import 'package:open_nutri/pages/authentification/welcome_page.dart';
import 'package:open_nutri/pages/history_page.dart';

import 'firebase_options.dart';
import 'models/product.dart';

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
      home: const AuthGate(),
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

  final List<Product> _history = [];

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _handleScan(String code) async {
    final product = await ProductService.fetchProductByCode(code);

    if (product != null) {
      setState(() {
        _history.insert(0, product);
      });

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit non trouvé")),
        );
      }
    }
  }

  final List<String> _titles = const [
    "Open Nutri",
    "Scan",
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      InfoPage(),
      HomePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
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
          TextButton.icon(
            onPressed: () => FirebaseAuth.instance.signOut(),

            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            label: const Text(
              "Déconnexion",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
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
            icon: const Icon(Icons.qr_code_scanner),
            title: const Text("Scan"),
            selectedColor: Colors.purple.shade700,
          ),
        ],
      ),
    );
  }
}

