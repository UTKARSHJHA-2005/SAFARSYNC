import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage>
    with TickerProviderStateMixin {
  static const Color _ink = Color(0xFF1A1A2E);
  static const Color _accent = Color(0xFF4F6EF7);
  static const Color _border = Color(0xFFE8EAF2);
  static const Color _surface = Colors.white;

  List<Contact> contacts = [];

  Future<void> pickContact() async {
    if (await FlutterContacts.requestPermission()) {
      final contact = await FlutterContacts.openExternalPick();

      if (contact != null && contact.phones.isNotEmpty) {
        setState(() {
          contacts.add(contact);
        });
      }
    }
  }

  Widget _nextButton(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: _accent.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 52),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Emergency Contacts",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                            letterSpacing: -0.5,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Step 2 of 2  •  Safety Setup",
                          style: TextStyle(
                            fontSize: 13,
                            color: _ink.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add at least 2 trusted contacts",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "These numbers will be contacted during emergencies.",
                        style: TextStyle(
                          fontSize: 13,
                          color: _ink.withOpacity(0.5),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CONTACT LIST
                      ...contacts.map((contact) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(color: _border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.contact_phone, color: _accent),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.displayName ?? "No Name",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      contact.phones.first.number ?? "",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _ink.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    contacts.remove(contact);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      /// ADD CONTACT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: pickContact,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Contact"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _accent,
                            side: const BorderSide(color: _accent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// CONTINUE BUTTON (SAME STYLE)
                _nextButton(() {
                  if (contacts.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please add at least 2 emergency contacts",
                        ),
                      ),
                    );
                    return;
                  }

                  // Navigate to profile or home
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
