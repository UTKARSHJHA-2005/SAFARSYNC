import 'package:flutter/material.dart';

Widget customField(
  String hint, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(border: InputBorder.none, hintText: hint),
    ),
  );
}

Widget nextBtn(VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: const Text("Next", style: TextStyle(color: Colors.white)),
    ),
  );
}

Widget termsText() {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: RichText(
      text: const TextSpan(
        style: TextStyle(color: Colors.black54, fontSize: 12),
        children: [
          TextSpan(text: "By registering, you agree with our "),
          TextSpan(
            text: "Terms & Conditions",
            style: TextStyle(color: Colors.blue),
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    ),
  );
}
