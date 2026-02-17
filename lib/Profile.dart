import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:safarsync/components/most.dart';
import 'package:safarsync/Your.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key});

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // PICK IMAGE FROM GALLERY OR CAMERA
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(
      source: source,
      imageQuality: 80, // compress slightly for better performance
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  // SHOW BOTTOM SHEET TO CHOOSE CAMERA OR GALLERY
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // GALLERY BUTTON
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
                const Text("Gallery"),
              ],
            ),

            // CAMERA BUTTON
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                const Text("Camera"),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                children: [
                  const Text(
                    "Add Your Profile Picture",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _imageFile == null
                          ? const Center(
                              child: Icon(Icons.image_outlined, size: 40),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  termsText(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            nextBtn(() {
              if (_imageFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please upload a profile picture"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterStep3()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
