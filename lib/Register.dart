import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:safarsync/components/most.dart';
import 'package:safarsync/Profile.dart';
import 'package:safarsync/components/input.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool otpVerified = false;

  String generatedOtp = "";
  String? selectedSex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // MAIN CONTAINER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FULL NAME
                    const Text("Full Name"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nameController,
                      decoration: customFieldDecoration("Enter your Full Name"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Full name is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // AGE
                    const Text("Age"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: customFieldDecoration("Enter your Age"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Age is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // SEX DROPDOWN
                    const Text("Sex"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: customDropDownDecoration(),
                      value: selectedSex,
                      hint: const Text("Select Sex"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                        DropdownMenuItem(
                          value: "Lesbian",
                          child: Text("Lesbian"),
                        ),
                        DropdownMenuItem(value: "Gay", child: Text("Gay")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSex = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select an option";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    const SizedBox(height: 16),

                    // PHONE NUMBER
                    const Text("Phone Number"),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: customFieldDecoration(
                              "Enter Phone Number",
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Phone number is required";
                              }
                              if (value.length < 10) {
                                return "Enter valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: () {
                            if (phoneController.text.length >= 10) {
                              setState(() {
                                generatedOtp =
                                    (1000 + (DateTime.now().millisecond % 9000))
                                        .toString();
                                otpSent = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("OTP Sent: $generatedOtp"),
                                ),
                              );
                            }
                          },
                          child: const Text("Send OTP"),
                        ),
                      ],
                    ),
                    if (otpSent) ...[
                      const SizedBox(height: 16),

                      const Text("Enter OTP"),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: customFieldDecoration("Enter OTP"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          if (otpController.text == generatedOtp) {
                            setState(() {
                              otpVerified = true;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("OTP Verified ✅")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid OTP ❌")),
                            );
                          }
                        },
                        child: const Text("Verify OTP"),
                      ),

                      const SizedBox(height: 10),

                      if (otpVerified)
                        const Text(
                          "Phone Verified Successfully",
                          style: TextStyle(color: Colors.green),
                        ),
                    ],

                    termsText(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              nextBtn(() {
                if (_formKey.currentState!.validate()) {
                  if (!otpVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please verify phone number first"),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterStep2()),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
