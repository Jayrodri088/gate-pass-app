// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gate_pass/admin_dashboard.dart';
import 'package:gate_pass/forgot_password.dart';
import 'package:gate_pass/sign_up.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  bool _passwordVisible = false;
  late AnimationController _buttonAnimationController;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);

    final url = Uri.parse(
        "http://10.10.2.34/gate-backend/signin.php"); // Replace with your backend URL

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      }),
    );

    setState(() => _isLoading = false);

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success']) {
      _showMessage("Login successful!", success: true);
      // Extract user ID from response
      String userId = responseData['data']['id'].toString();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminDashboardScreen(userId: userId)));
    } else {
      _showMessage(responseData['message'] ?? "Invalid email or password.");
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Blue background for the header section
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with logo
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png', // Update to your actual logo path
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ),

            // White rounded container for the form
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Centered title
                  const Text(
                    "Let's Get to know You",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab options for "Sign Up" and "Sign In"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignUpScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(
                                    -1.0, 0.0); // Start from the right side
                                const end = Offset.zero; // End at the center
                                const curve = Curves.easeInOut;

                                final tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                final offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.blue, thickness: 2, indent: 255),

                  const SizedBox(height: 20),

                  // Email field with customized cursor and focused border
                  TextField(
                    controller: _emailController,
                    cursorColor: Colors.blue, // Sets cursor color to blue
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: "Enter your Email",
                      hintStyle: const TextStyle(fontSize: 15),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2), // Blue color for active border
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password field with visibility toggle
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.blue, // Sets cursor color to blue
                    obscureText:
                        !_passwordVisible, // Toggles password visibility
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible =
                                !_passwordVisible; // Toggle password visibility
                          });
                        },
                      ),
                      hintText: "Enter your Password",
                      hintStyle: const TextStyle(fontSize: 15),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2), // Blue color for active border
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password Text Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ForgotPasswordScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                                  Offset(0.0, 1.0); // Start from the right side
                              const end = Offset.zero; // End at the center
                              const curve = Curves.easeInOut;

                              final tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 150),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Bottom text with correct styling
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue, // Blue color for the initial text
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.orange, // Orange color for "Sign Up"
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const SignUpScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0,
                                          1.0); // Start from the right side
                                      const end =
                                          Offset.zero; // End at the center
                                      const curve = Curves.easeInOut;

                                      final tween =
                                          Tween(begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                      final offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
