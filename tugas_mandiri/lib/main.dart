import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AccidentReportApp());
}

class AccidentReportApp extends StatelessWidget {
  const AccidentReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pelaporan Kecelakaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}