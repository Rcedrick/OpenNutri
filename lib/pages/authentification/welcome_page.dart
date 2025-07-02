import 'package:flutter/material.dart';
import 'package:open_nutri/pages/authentification/signin_page.dart';
import 'package:open_nutri/pages/authentification/signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: 64, color: Colors.white),
              SizedBox(height: 20),
              Text("OPEN FOOD",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SignInPage())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: Colors.white),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12)),
                child: Text("SIGN IN", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SignUpPage())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12)),
                child: Text("SIGN UP",
                    style: TextStyle(color: Colors.red.shade700)),
              ),
              SizedBox(height: 30),
              Text("Login with Social Media",
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.facebook, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.email, color: Colors.white),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
