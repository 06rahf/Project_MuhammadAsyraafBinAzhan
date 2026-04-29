import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "";
  String password = "";
  bool isLoading = false;

  void handleLogin() async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila isi emel dan kata laluan')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await context.read<AppState>().login(email, password);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal: Emel atau Kata Laluan Salah')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Susun semua ke tengah
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.teal),
            const SizedBox(height: 20),

            // email
            TextField(
              onChanged: (val) => email = val,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // Input Password
            TextField(
              onChanged: (val) => password = val,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            // Butang Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: isLoading ? null : handleLogin,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('LOGIN', style: TextStyle(color: Colors.white)),
              ),
            ),

            // Link ke Signup & Integrity
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('Daftar Akaun Baru'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/academic_integrity'),
              child: const Text('Academic Integrity Compliance'),
            ),
          ],
        ),
      ),
    );
  }
}