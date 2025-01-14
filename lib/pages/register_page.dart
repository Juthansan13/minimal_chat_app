import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        await auth.signUpWithEmailPassword(
           _nameController.text,
          _emailController.text,
          _pwController.text,
         
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.7),
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.message,
                    size: 60,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 30),

                // Welcome Text
                Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Fill in the details below to sign up.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.email, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password TextField
                TextField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password TextField
                TextField(
                  controller: _confirmPwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Register Button
                ElevatedButton(
                  onPressed: () => register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 135.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
                        );
                      },
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
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
    );
  }
}
