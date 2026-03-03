import 'dart:ui';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// 🔵 Light Gradient Background (Blue at Top)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9893FF), // Blue top
                  Color(0xFFEFF4FF), // Light bottom
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// 🔙 Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _glassIconButton(
                        Icons.arrow_back_ios_new_rounded,
                        Colors.blueAccent,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        "Help & Support",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 42),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 📖 Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      children: [
                        _sectionTitle("Frequently Asked Questions"),
                        const SizedBox(height: 16),
                        _faqCard(
                          "How does the AI work?",
                          "Our AI analyzes your input and generates smart responses instantly.",
                        ),
                        _faqCard(
                          "Is my data secure?",
                          "Yes, your data is encrypted and the authentication one is stored on Blockchain and never shared with third parties.",
                        ),
                        _faqCard(
                          "How much time will it take for the app to inform the authorities and friends after an emergency?",
                          "The app sends an immediate alert to the authorities and friends within 10 seconds of detecting an emergency.",
                        ),

                        const SizedBox(height: 30),

                        _sectionTitle("Need More Help?"),

                        const SizedBox(height: 16),

                        _buildQueryBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// 🔹 FAQ Card
  Widget _faqCard(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildQueryBox() {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Send us your question",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),

          /// Input Field
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Write your query here...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🚀 Send Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Handle send logic
                print(controller.text);
                controller.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5BFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Send Message",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glass Button
  Widget _glassIconButton(
    IconData icon,
    Color color, {
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.white.withOpacity(0.18),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
