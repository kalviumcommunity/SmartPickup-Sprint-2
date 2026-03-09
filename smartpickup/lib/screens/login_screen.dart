import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final auth = AuthService();

  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    final user =
        await auth.login(emailController.text.trim(), passController.text.trim());

    setState(() => loading = false);

    if (user != null) {
      /// ✅ GO TO HOME SCREEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartPickup Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Colors.green),
            const SizedBox(height: 20),

            CustomTextField(
              controller: emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              controller: passController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),

            const SizedBox(height: 25),

            CustomButton(
              label: 'Login',
              icon: Icons.login,
              onPressed: loading ? null : login,
              isLoading: loading,
              width: double.infinity,
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              },
              child: const Text("Create account"),
            )
          ],
        ),
      ),
    );
  }
}