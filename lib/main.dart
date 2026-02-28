import 'package:flutter/material.dart';
import 'package:safarsync/phone.dart';
import 'package:safarsync/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhoneInputScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const PhoneInputScreen());
  }
}
