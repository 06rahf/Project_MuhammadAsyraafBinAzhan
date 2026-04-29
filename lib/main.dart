import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Import fail halaman anda
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'academic_integrity_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. KONFIGURASI FIREBASE (MENGGUNAKAN ID PROJEK MOBILEAPP-3851C)
  const firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyCWE788j3rHaBV1EZtHpquJJ4hSzPDCsVI",
    authDomain: "mobileapp-3851c.firebaseapp.com",
    databaseURL: "https://mobileapp-3851c-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "mobileapp-3851c",
    storageBucket: "mobileapp-3851c.firebasestorage.app",
    messagingSenderId: "587050464426",
    appId: kIsWeb 
        ? "1:587050464426:web:143ec6a6b605d52ad0ccd3" // Web ID
        : "1:587050464426:android:568530edf6dbd0f4d0ccd3", // Android ID
  );

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: firebaseOptions);
    }
    debugPrint("Firebase Connected!");
  } catch (e) {
    debugPrint("Firebase Error: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

// 2. LOGIC PENGURUSAN DATA (APPSTATE)
class AppState extends ChangeNotifier {
  late final DatabaseReference _dbRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Pembolehubah data sensor
  double temperature = 0.0;
  double humidity = 0.0;
  double distance = 999.0;
  bool gasDetected = false;
  bool isLedOn = false;
  bool isBuzzerOn = false;

  AppState() {
    // Sambungkan ke Realtime Database
    _dbRef = FirebaseDatabase.instance.ref();

    // MULA MENDENGAR DATA DARI ARDUINO (FOLDER 'smart_toilet')
    _dbRef.child('smart_toilet').onValue.listen((event) {
      if (event.snapshot.value != null) {
        try {
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          
          // Tukar data dari Firebase ke dalam aplikasi
          temperature = double.tryParse(data['temperature']?.toString() ?? '0.0') ?? 0.0;
          humidity = double.tryParse(data['humidity']?.toString() ?? '0.0') ?? 0.0;
          distance = double.tryParse(data['distance']?.toString() ?? '0.0') ?? 999.0;
          
          // Status Gas & Aktuator (Membaca "1" sebagai ON)
          gasDetected = (data['gas']?.toString() == "1");
          isLedOn = (data['led_status']?.toString() == "1");
          isBuzzerOn = (data['buzzer_status']?.toString() == "1");

          notifyListeners(); // Update paparan skrin secara automatik
        } catch (e) {
          debugPrint("Error processing data: $e");
        }
      }
    });
  }

  // FUNGSI KAWALAN LED
  void toggleLed() {
    String newValue = isLedOn ? "0" : "1";
    _dbRef.child('smart_toilet').update({'led_status': newValue});
  }

  // FUNGSI KAWALAN BUZZER
  void toggleBuzzer() {
    String newValue = isBuzzerOn ? "0" : "1";
    _dbRef.child('smart_toilet').update({'buzzer_status': newValue});
  }

  // FUNGSI AUTHENTICATION
  Future<void> login(String e, String p) async => _auth.signInWithEmailAndPassword(email: e, password: p);
  Future<void> signUp(String e, String p) async => _auth.createUserWithEmailAndPassword(email: e, password: p);
  void logout() => _auth.signOut();
}

// 3. STRUKTUR UTAMA APLIKASI
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      // Tentukan halaman mula-mula
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
