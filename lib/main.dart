import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gate Pass App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
        // Customizing the default input decoration theme for TextFields and DropdownButtonFormFields
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blue, width: 2), // Blue border when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey, width: 1), // Grey border when not focused
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey, width: 1), // Default border style
          ),
          hintStyle: const TextStyle(color: Colors.black54), // Hint text color
        ),

        // Customizing text selection colors for TextFields
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,       // Blue cursor color
          selectionColor: Colors.blueAccent, // Light blue selection color
          selectionHandleColor: Colors.blue, // Blue selection handle
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
