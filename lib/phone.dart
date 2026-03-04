import 'package:flutter/material.dart';
import 'package:safarsync/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:safarsync/Hello.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String completePhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF4FF), Color(0xFF9893FF)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to",
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              const Text(
                "SafarSync",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // PHONE INPUT
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntlPhoneField(
                  controller: phoneController,
                  initialCountryCode: 'IN', // change default if needed
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your phone number",
                  ),
                  dropdownIconPosition: IconPosition.trailing,
                  flagsButtonPadding: const EdgeInsets.all(8),
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return "Phone number is required";
                    }
                    // if (phone.number.length < 6) {
                    //   return "Enter a valid phone number";
                    // }
                    return null;
                  },
                  onChanged: (phone) {
                    completePhoneNumber = phone.completeNumber;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final phone = completePhoneNumber.trim();
                      final response = await http.get(
                        Uri.parse(
                          "https://safarsync-7g9l.onrender.com/verify-user/${Uri.encodeComponent(phone)}",
                        ),
                      );

                      if (response.statusCode != 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Server error")),
                        );
                        return;
                      }

                      final exists = jsonDecode(response.body)["exists"];

                      if (exists == true) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("isLoggedIn", true);
                        await prefs.setString("userPhone", phone);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Hello()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "User not registered. Please signup.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // LOGIN LINK
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterStep1()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Newbie? ", style: TextStyle(color: Colors.black54)),
                      Text(
                        "Signup",
                        style: TextStyle(
                          color: Color.fromARGB(255, 57, 39, 60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
