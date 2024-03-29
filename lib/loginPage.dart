import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebaseServices.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginButton() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print('User logged in: ${user.uid}');
      Navigator.pushNamed(context, '/home');
    } else {
      // Handle login failure, show error message
      showLoginErrorSnackbar(context, 'Invalid email or password');
      clear();
    }
  }

  void forgotPassword() async {
    String email = _emailController.text.trim();

    try {
      await _authService.sendPasswordResetEmail(email);
      showForgotPasswordSnackbar(context, 'Password reset email sent');
    } catch (e) {
      showForgotPasswordSnackbar(context, 'Error sending password reset email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                loginButton();
              },
              child: Text('Login', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                forgotPassword();
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(primary: Colors.blueAccent),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Create a new account",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Register Now",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(primary: Colors.blueAccent),
            )
          ],
        ),
      ),
    );
  }

  void clear() {
    _emailController.clear();
    _passwordController.clear();
  }

  void showLoginErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showForgotPasswordSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
