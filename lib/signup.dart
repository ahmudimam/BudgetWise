
import 'package:flutter/material.dart';
import 'firebaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signUpButton() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      showSignUpErrorSnackbar(context, 'Passwords do not match');
      clearFields();
    }

    User? user = await _authService.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print('User registered: ${user.uid}');
      Navigator.pushNamed(context, '/home');
    } else {
      showSignUpErrorSnackbar(context, 'Empty fields');
      clearFields();
    }
  }

  void signUpWithGoogle() async {
    User? user = await _authService.signUpWithGoogle();

    if (user != null) {
      print('User registered with Google: ${user.uid}');
      Navigator.pushNamed(context, '/home');
    } else {
      showSignUpErrorSnackbar(context, 'Google Sign-Up failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signUpButton();
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                signUpWithGoogle();
              },
              child: Text('Sign Up with Google'),
            ),
            SizedBox(height: 10),
            Text("Already have an account?",
                style: TextStyle(color: Colors.grey)),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child:
                  Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                primary: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void showSignUpErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
