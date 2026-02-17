import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:safarsync/components/most.dart';

class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({super.key});

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tell something about yourself"),
                  const SizedBox(height: 30),

                  // INPUT BOX
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: aboutController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write something...",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  termsText(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (aboutController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please write something about yourself"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully registered!"),
                      backgroundColor: Colors.green,
                    ),
                  );
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
          ],
        ),
      ),
    );
  }
}
