import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/NewScreen/LandingScreen.dart';
import 'package:flutter_whatsapp/Screens/LoginScreen.dart';
import 'Screens/Homescreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter_whatsapp/Screens/CameraScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: Colors.white,
        accentColor: Colors.white70
      ),
      home: LandingScreen(),
    );
  }
}