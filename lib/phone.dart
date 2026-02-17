import 'package:flutter/material.dart';
import 'package:safarsync/Register.dart';
import 'package:safarsync/otp.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

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
                child: TextFormField(
                  controller: phoneController,
                  textAlign: TextAlign.center, // << center text & hint
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your phone number",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    prefixIcon: Icon(Icons.phone), // you can remove if you want
                  ),

                  // REQUIRED VALIDATION
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (value.length < 10) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate field
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OtpVerificationScreen(),
                        ),
                      );
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
