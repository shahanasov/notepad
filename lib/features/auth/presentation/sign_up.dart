import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notepad/features/auth/domain/auth_service_provider.dart';
import 'package:notepad/features/auth/presentation/sign_in.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  void handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      await ref
          .read(authServiceProvider)
          .signUp(email.trim(), password.trim());
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Account created successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      
      // Optional: Manual navigation (uncomment if you prefer explicit control)
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Signup failed: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
  key: _formKey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Header
      const Text(
        "Create Account",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      
      // Email Field
      TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (val) => email = val,
        validator: (val) =>
            val != null && val.contains('@') ? null : "Invalid email",
      ),
      const SizedBox(height: 20),
      
      // Password Field
      TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        onChanged: (val) => password = val,
        validator: (val) =>
            val != null && val.length >= 6 ? null : "Min 6 characters",
      ),
      const SizedBox(height: 32),
      
      // Sign Up Button
      loading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: handleSignup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Create Account",
                style: TextStyle(fontSize: 16),
              ),
            ),
      const SizedBox(height: 20),
      
      // Divider with "OR" text
      Row(
        children: const [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("OR"),
          ),
          Expanded(child: Divider()),
        ],
      ),
      const SizedBox(height: 20),
      
      // Sign In Option
      TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: "Sign In",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
      ),
    );
  }
}
