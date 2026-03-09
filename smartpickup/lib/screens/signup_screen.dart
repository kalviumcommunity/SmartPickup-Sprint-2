import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final auth = AuthService();

  void signup() async {
    final user = await auth.signup(email.text, pass.text);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            CustomTextField(
              controller: email,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: pass,
              label: 'Password',
              hint: 'Min 6 characters',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Sign Up',
              icon: Icons.person_add_outlined,
              onPressed: signup,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
