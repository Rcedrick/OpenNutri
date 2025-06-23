import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
            SizedBox(height: 60),
            Text("Create Your Account",
                style: TextStyle(fontSize: 28, color: Colors.white)),
            SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Full Name",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.check),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Phone or Gmail",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.check),
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
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: StadiumBorder(),
                  backgroundColor: Colors.black87),
              child: Text("SIGN UP"),
            ),
            SizedBox(height: 10),
            Text("Already have account?",
                style: TextStyle(color: Colors.white70)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Sign In", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

