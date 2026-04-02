import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'academic_integrity_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Tetap perlukan google-services.json
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  // Gunakan URL database anda secara spesifik kerana ia di region asia-southeast1
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://flutterauthapp-7a7b7-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref(); // Kita guna root ref atau 'smart_toilet'

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Data Sensor
  double temperature = 0.0;
  double humidity = 0.0;
  double distance = 999.0;
  int sitTime = 0;
  bool gasDetected = false;
  
  // Data Actuators
  bool isFanOn = false;
  bool isLocked = false;

  AppState() {
    // Memantau path 'smart_toilet' secara spesifik
    _dbRef.child('smart_toilet').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        
        temperature = (data['temperature'] ?? 0.0).toDouble();
        humidity = (data['humidity'] ?? 0.0).toDouble();
        distance = (data['distance'] ?? 999.0).toDouble();
        sitTime = (data['sit_time'] ?? 0).toInt();
        gasDetected = (data['gas'] ?? 0) == 1;
        
        // Sesuai dengan status yang dikawal dari app atau hardware
        isFanOn = (data['fan_status'] ?? 0) == 1;
        isLocked = (data['lock_status'] ?? 0) == 1;
        
        notifyListeners();
      }
    });

    _auth.authStateChanges().listen((User? user) {
      _isLoggedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _auth.signOut();
  }

  void toggleFan() {
    isFanOn = !isFanOn;
    _dbRef.child('smart_toilet').update({'fan_status': isFanOn ? 1 : 0});
    notifyListeners();
  }

  void toggleLock() {
    isLocked = !isLocked;
    _dbRef.child('smart_toilet').update({'lock_status': isLocked ? 1 : 0});
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Toilet Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/academic_integrity': (context) => const AcademicIntegrityPage(),
      },
    );
  }
}
