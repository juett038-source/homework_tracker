import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'home_screen.dart';


void main() {
  runApp(const HomeworkTrackerApp());
}

class HomeworkTrackerApp extends StatelessWidget {
  const HomeworkTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Tracker',
      theme: ThemeData(primarySwatch: Colors.blue), 
      home: const SplashScreen(),
    );
  }
}

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen(),
        ),
        );
    });
  }
      
  @override
  Widget build(BuildContext context) {
    return Container(
      //backgroundColor: Colors.blue,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          'Homework Tracker',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        )
      )
    );
  }
}
