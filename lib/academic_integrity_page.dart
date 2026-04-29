import 'package:flutter/material.dart';

class AcademicIntegrityPage extends StatelessWidget {
  const AcademicIntegrityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Integrity'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Student Declaration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            const Text(
              'I, Muhammad Asyraaf bin Azhan, declare that this IoT project is my own work. I have not copied this project from any other sources illegally.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            const Divider(), //
            const SizedBox(height: 20),


            const Text(
              'References:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            const Text('• Flutter Official Documentation (https://docs.flutter.dev)'),
            const SizedBox(height: 5),
            const Text('• Firebase Realtime Database (https://firebase.google.com)'),
            const SizedBox(height: 5),
            const Text('• Arduino ESP32 Library (https://github.com/mobizt/Firebase-ESP32)'),

            const SizedBox(height: 30),


            const Center(
              child: Text(
                '✅ Verified Student Submission',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
