import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Toilet System'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.pushReplacementNamed(context, '/login'); // TAMBAH INI
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wc, size: 64, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Toilet Management',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Monitoring Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Academic Integrity'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/academic_integrity');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                context.read<AppState>().logout();
                Navigator.pushReplacementNamed(context, '/login'); // TAMBAH INI JUGA
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(appState),
            const SizedBox(height: 24),

            const Text(
              'Live Sensor Readings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildSensorCard(
                  Icons.thermostat,
                  'Temp',
                  '${appState.temperature.toStringAsFixed(1)}°C',
                  Colors.orange,
                ),
                _buildSensorCard(
                  Icons.water_drop,
                  'Humidity',
                  '${appState.humidity.toStringAsFixed(1)}%',
                  Colors.blue,
                ),
                _buildSensorCard(
                  Icons.social_distance,
                  'Distance',
                  '${appState.distance.toStringAsFixed(1)} cm',
                  Colors.purple,
                ),
                _buildSensorCard(
                  Icons.timer,
                  'Sit Time',
                  '${appState.sitTime}s',
                  Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Environmental Safety',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: appState.gasDetected ? Colors.red.shade50 : Colors.green.shade50,
              child: ListTile(
                leading: Icon(
                  appState.gasDetected ? Icons.warning : Icons.check_circle,
                  color: appState.gasDetected ? Colors.red : Colors.green,
                ),
                title: Text(
                  appState.gasDetected ? 'GAS DETECTED!' : 'Air Quality: Clean',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appState.gasDetected ? Colors.red : Colors.green,
                  ),
                ),
                subtitle: const Text('Monitoring MQ135 Sensor'),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Actuators & Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildControlCard(
              Icons.mode_fan_off_outlined,
              'Ventilation Fan',
              'Fan helps clear odor/gas',
              appState.isFanOn,
              (val) => appState.toggleFan(),
              Colors.teal,
            ),
            const SizedBox(height: 10),
            _buildControlCard(
              Icons.door_front_door,
              'Door Solenoid Lock',
              'Control door accessibility',
              appState.isLocked,
              (val) => appState.toggleLock(),
              Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(AppState state) {
    bool isOccupied = state.distance > 2 && state.distance < 200;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOccupied ? Colors.redAccent : Colors.teal.shade700,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            isOccupied ? Icons.person : Icons.no_accounts,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(
            isOccupied ? 'TOILET OCCUPIED' : 'TOILET EMPTY',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(IconData icon, String label, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard(IconData icon, String title, String sub, bool isOn, Function(bool) onChanged, Color activeColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOn ? activeColor : Colors.grey.shade200,
          child: Icon(icon, color: isOn ? Colors.white : Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: Switch(
          value: isOn,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
      ),
    );
  }
}
