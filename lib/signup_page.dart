import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Menghubungkan dengan logic Firebase

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 1. Controller untuk ambil data input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 2. Fungsi Daftar
  void _handleSignup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila isi emel dan kata laluan')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Panggil fungsi signUp dari main.dart
      await context.read<AppState>().signUp(email, password);
      
      if (mounted) {
        // --- PERUBAHAN DI SINI ---
        // Kita log keluar dulu supaya user terpaksa login semula
        context.read<AppState>().logout(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran Berjaya! Sila log masuk.'),
            backgroundColor: Colors.green,
          ),
        );

        // Pergi ke Login Page bukannya Home
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akaun'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.person_add, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                'Cipta Akaun Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Input Emel
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Emel Baru',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Input Kata Laluan
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Laluan Baru',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),

              // Butang DAFTAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('DAFTAR SEKARANG', style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),

              // Balik ke Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Sudah ada akaun? Log Masuk di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
