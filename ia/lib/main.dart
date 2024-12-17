import 'package:flutter/material.dart';
import 'package:ia/pages/home.dart';
// Import the Homepage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => HomePage(), // Define the Homepage route
        // Optional: Define '/Homepages' if needed
      },
    );
  }
}
