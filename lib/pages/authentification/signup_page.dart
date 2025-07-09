import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/customise_utils.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();

  final PageController _pageController = PageController();

  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> signUp() async {
    if (_formKeyStep2.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        FocusScope.of(context).unfocus();

        await authService.value.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'firstName': _capitalize(firstNameController.text.trim()),
            'lastName': lastNameController.text.trim().toUpperCase(),
            'pseudo': _capitalize(pseudoController.text.trim()),
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        showCustomSnackBar(context, "Inscription terminée ");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'Erreur : ${e.code}';
        if (e.code == 'email-already-in-use') {
          message = 'Cet email est déjà utilisé';
        } else if (e.code == 'network-request-failed') {
          message = 'Vérifiez votre connexion internet';
        }
        showCustomSnackBar(context, message);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
          ? const LinearProgressIndicator(
        color: Colors.deepPurple,
        backgroundColor: Colors.deepPurpleAccent,
      )
          : null,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Form(
            key: _formKeyStep1,
            child: Center(
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _logo(),
                        _gap(),
                        Text(
                          "Bienvenue sur Open Nutri",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        _gap(),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Champ vide';
                            }
                            bool emailValid = RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value);
                            if (!emailValid) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        _gap(),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Champ vide';
                            }
                            if (value.length < 6) {
                              return '6 caractères minimum';
                            }
                            return null;
                          },
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                        ),
                        _gap(),
                        TextFormField(
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirmez le mot de passe';
                            }
                            if (value != passwordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirmer mot de passe',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        _gap(),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKeyStep1.currentState?.validate() ?? false) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: const Text('Suivant'),
                        ),
                        _gap(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous avez déjà un compte ? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Se connecter",
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Form(
            key: _formKeyStep2,
            child: Center(
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _logo(),
                        _gap(),
                        Text(
                          "Profil Open Nutri",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        _gap(),
                        TextFormField(
                          controller: lastNameController,
                          onChanged: (value) {
                            final upper = value.toUpperCase();
                            if (value != upper) {
                              lastNameController.value = lastNameController.value.copyWith(
                                text: upper,
                                selection: TextSelection.collapsed(offset: upper.length),
                              );
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        _gap(),
                        TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'Prénom',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        _gap(),
                        TextFormField(
                          controller: pseudoController,
                          decoration: const InputDecoration(
                            labelText: 'Pseudo',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        _gap(),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Text('Précédent'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : signUp,
                                child: const Text('Finaliser'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Widget _logo() => ClipOval(
    child: Image.asset(
      'assets/images/logo.png',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
    ),
  );
}
