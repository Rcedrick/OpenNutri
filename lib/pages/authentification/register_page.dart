import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_nutri/pages/authentification/login_page.dart';
import 'package:open_nutri/pages/home_page.dart';
import 'package:open_nutri/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void register() async {
    try {
      await authService.value.signUp(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Une erreur est survenue';
      });
    }
  }

  void popPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Create Your Account",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 30),

            Form(
              key: formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Phone or Gmail",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.check),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 20),
                  // Mot de passe
                  TextFormField(
                    controller: passwordController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      } else if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: _toggleVisibility,
                      ),
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bouton
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                shape: const StadiumBorder(),
                backgroundColor: Colors.black87,
              ),
              child: const Text("SIGN UP"),
            ),

            // Message d'erreur général
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade200),
                ),
              ),

            const SizedBox(height: 10),
            const Text(
              "Already have account?",
              style: TextStyle(color: Colors.white70),
            ),
            TextButton(
              onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              },
              child: const Text("Sign In", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}