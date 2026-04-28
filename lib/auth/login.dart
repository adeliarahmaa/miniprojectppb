import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    try {
      await auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal: $e")));
    }

    setState(() => loading = false);
  }

  Future<void> register() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register berhasil")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🍱 MoodBite Login", style: TextStyle(fontSize: 24)),

              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),

              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: login,
                          child: const Text("Login"),
                        ),
                        TextButton(
                          onPressed: register,
                          child: const Text("Register"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
