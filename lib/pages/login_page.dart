import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
 // final FocusNode _emailFocusNode = FocusNode();
  //final FocusNode _pwFocusNode = FocusNode();
  //final FocusNode _nameFocusNode = FocusNode();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
  final authService = AuthService();
  String email = _emailController.text.trim();
  String password = _pwController.text.trim();

  bool isValidEmail(String email) {
  final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return emailRegExp.hasMatch(email);
}


  if (!isValidEmail(email)) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Email Format"),
        content: const Text("Please enter a valid email address."),
      ),
    );
    return;  // Stop further execution if email is invalid
  }

  try {
    await authService.signInWithEmailPassword(email, password);

    // Navigate to the home page upon success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } catch (e) {
    print("Error: $e");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(e.toString()),
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
                // Logo or Icon
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

                // Welcome text
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We're glad to see you again. Log in to continue.",
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

                // Login Button

                 ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 140.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Registration prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(onTap: () {}),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontSize: 14,
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
