import 'package:flutter/material.dart';

InputDecoration customFieldDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

InputDecoration customDropDownDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
