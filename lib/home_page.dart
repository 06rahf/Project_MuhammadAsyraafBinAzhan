import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "User";

    if (appState.gasDetected) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("⚠️ AMARAN: Gas Bahaya Dikesan!"),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              accountName: Text(email.split('@')[0].toUpperCase()),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Academic Integrity"),
              onTap: () => Navigator.pushNamed(context, '/academic_integrity'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                context.read<AppState>().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/profile.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.teal.shade100,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.teal),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _sensorBox("Suhu", "${appState.temperature.toStringAsFixed(1)}°C", Colors.orange),
                const SizedBox(width: 8),
                _sensorBox("Humid", "${appState.humidity.toStringAsFixed(1)}%", Colors.blue),
                const SizedBox(width: 8),
                _sensorBox("Jarak", "${appState.distance.toStringAsFixed(1)}cm", Colors.purple),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appState.gasDetected ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                appState.gasDetected ? "⚠️ GAS BAHAYA!" : "✅ GAS BERSIH",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            const SizedBox(height: 30),
            const Text("Kawalan Peranti", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            SwitchListTile(
              title: const Text("Lampu LED (Pin 15)"),
              secondary: Icon(Icons.lightbulb, color: appState.isLedOn ? Colors.amber : Colors.grey),
              value: appState.isLedOn,
              onChanged: (val) => appState.toggleLed(),
            ),

            SwitchListTile(
              title: const Text("Buzzer (Pin 4)"),
              secondary: Icon(Icons.campaign, color: appState.isBuzzerOn ? Colors.red : Colors.grey),
              value: appState.isBuzzerOn,
              onChanged: (val) => appState.toggleBuzzer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorBox(String tajuk, String nilai, Color warna) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: warna.withOpacity(0.1),
          border: Border.all(color: warna, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(nilai, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(tajuk, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
