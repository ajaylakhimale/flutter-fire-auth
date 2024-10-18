import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({required this.user});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Send email verification to the user if not verified
    if (!widget.user.emailVerified) {
      widget.user.sendEmailVerification();
    }

    // Set up a Timer to periodically reload the user data
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await widget.user.reload(); // Reload user data
      var user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        // If the email is verified, navigate to the HomeScreen
        timer.cancel(); // Stop the timer
        setState(() {}); // Force the UI to rebuild
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    // Check if the email is now verified
    if (user != null && user.emailVerified) {
      return const HomeScreen(); // Automatically redirect to HomeScreen
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('An email verification link has been sent to your email.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Manually trigger email verification if needed
                widget.user.sendEmailVerification();
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
