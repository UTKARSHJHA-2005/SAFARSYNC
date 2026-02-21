import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController blockchainController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emergencyController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isOrganDonor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// 🔹 Profile Image
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/profile.jpg"),
                      // replace or make dynamic later
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, size: 18),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// 🔹 Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildTextField("Full Name", nameController),
                      _buildTextField("Blockchain ID", blockchainController),
                      _buildTextField("Phone Number", phoneController),
                      _buildTextField(
                        "Emergency Contacts",
                        emergencyController,
                      ),
                      _buildTextField("Blood Type", bloodController),
                      _buildTextField("Medications", medicationController),
                      _buildTextField(
                        "Address",
                        addressController,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 15),

                      /// 🔹 Organ Donor Switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Organ Donor",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value: isOrganDonor,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                isOrganDonor = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            // Add save logic here
                          },
                          child: const Text(
                            "Save Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable TextField
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
