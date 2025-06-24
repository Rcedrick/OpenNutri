import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_nutri/pages/authentification/register_page.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  String errorMessage = '';

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void singIn() async {
    try {
      await authService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      popPage();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage= e.message ?? "This is not working";
      });
    }
  }

  void popPage(){
    Navigator.pop(context);
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

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello\nSign in!",
                style: TextStyle(fontSize: 32, color: Colors.white)),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Gmail",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot password?", style: TextStyle(color: Colors.white)),
              ),
            ),
            ElevatedButton(
              onPressed: () => singIn(),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: StadiumBorder(),
                  backgroundColor: Colors.black87),
              child: Text("LOGIN"),
            ),
            SizedBox(height: 10),
            Text("Don’t have account?",
                style: TextStyle(color: Colors.white70)),
            TextButton(
              onPressed: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
              );
              },
              child: Text("Sign up", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
