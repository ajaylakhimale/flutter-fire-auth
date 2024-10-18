import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<void> signUp() async {
    try{
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      User? user = userCredential.user;
      print(user);

    }on FirebaseAuthException catch (e){
      if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }}
  }
  Future<void> signIn() async {
    try{
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      User? user = userCredential.user;
   print(user);
    }on FirebaseAuthException catch (e){
      if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }}
  }



  bool isSignup = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo or Title
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            // Email Field
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Password Field
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Signin/Signup Button
            ElevatedButton(
              onPressed: () {
                // Handle signin/signup logic
                isSignup?signUp():signIn();
              },
              child: Text(isSignup ? 'Sign up' : 'Sign in'),
            ),
            const SizedBox(height: 10),
            // Toggle Button
            TextButton(
              onPressed: () {
                setState(() {
                  isSignup = !isSignup;
                });
              },
              child: Text(isSignup
                  ? 'Already have an account? Sign in'
                  : 'Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
