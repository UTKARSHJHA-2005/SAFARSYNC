import 'package:flutter/material.dart';
import 'package:flutter_contact_picker/flutter_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<PhoneContact> contacts = [];

  Future<void> pickContact() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      try {
        PhoneContact contact = await FlutterContactPicker.pickPhoneContact();

        if (contact.phoneNumber != null) {
          setState(() {
            contacts.add(contact);
          });
        }
      } catch (e) {
        debugPrint("Error picking contact: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contacts permission denied")),
      );
    }
  }

  void removeContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Contacts")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add at least 2 emergency contacts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "These numbers will be called during emergency situations.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Contact List
            Expanded(
              child: contacts.isEmpty
                  ? const Center(
                      child: Text(
                        "No contacts added yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.contact_phone),
                            title: Text(contact.fullName ?? "No Name"),
                            subtitle: Text(contact.phoneNumber?.number ?? ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeContact(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            /// Add Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Contact"),
                onPressed: pickContact,
              ),
            ),

            const SizedBox(height: 15),

            /// Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: contacts.length >= 2
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Emergency contacts saved successfully",
                            ),
                          ),
                        );

                        // Navigate next if needed
                      }
                    : null,
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
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
