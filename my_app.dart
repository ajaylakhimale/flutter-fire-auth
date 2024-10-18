class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      // Needed for Timer

      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for connection
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If the user is authenticated (snapshot.data is not null)
          if (snapshot.hasData) {
            User? user = snapshot.data;

            // Check if the email is verified
            if (!user!.emailVerified) {
              return EmailVerificationScreen(user: user);
            }

            // If email is verified, navigate to HomeScreen
            return const HomeScreen();
          }

          // If the user is not logged in, navigate to the LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
