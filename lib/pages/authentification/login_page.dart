import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void singUserIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("Email: $email");
    print("Password: $password");
    if (email.isEmpty || password.isEmpty) {
      print("Champs vides");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("e.code = ${e.code}");
      if (e.code == 'user-not-found') {
        print("Utilisateur non trouvé");
      } else if (e.code == 'wrong-password') {
        print("mot de passe incorrect");
      }
    }
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
            TextField(
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

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                suffixIcon: Icon(Icons.visibility_off),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot password?", style: TextStyle(color: Colors.white)),
              ),
            ),
            ElevatedButton(
              onPressed: () => singUserIn(),
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
              onPressed: () => Navigator.pop(context),
              child: Text("Sign up", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
