import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safarsync/components/gradient.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safarsync/Home.dart';
import 'package:safarsync/State.dart';
import 'package:safarsync/model/user_register.dart';

class EmergencyContactsPage extends StatefulWidget {
  final UserRegistration user;

  const EmergencyContactsPage({super.key, required this.user});
  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage>
    with TickerProviderStateMixin {
  static const Color _ink = Color(0xFF1A1A2E);
  static const Color _accent = Color(0xFF4F6EF7);
  static const Color _border = Color(0xFFE8EAF2);
  static const Color _surface = Colors.white;
  late Web3Client web3client;
  final String contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";
  final String abiJson = '''[
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "user",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "newCID",
                "type": "string"
            }
        ],
        "name": "ProfileUpdated",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "user",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "phoneHash",
                "type": "string"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "profileCID",
                "type": "string"
            }
        ],
        "name": "UserRegistered",
        "type": "event"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_user",
                "type": "address"
            }
        ],
        "name": "getProfileCID",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "_profileCID",
                "type": "string"
            }
        ],
        "name": "registerUser",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_newCID",
                "type": "string"
            }
        ],
        "name": "updateProfile",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_phoneHash",
                "type": "string"
            }
        ],
        "name": "verifyPhone",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
]''';

  List<Contact> contacts = [];
  final String rpcUrl = "https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID";
  @override
  void initState() {
    super.initState();
    web3client = Web3Client(rpcUrl, http.Client());
  }

  Future<void> pickContact() async {
    final permission = await FlutterContacts.requestPermission();

    print("Permission granted: $permission");

    if (!permission) return;

    final picked = await FlutterContacts.openExternalPick();

    print("Picked contact: $picked");

    if (picked == null) return;

    final fullContact = await FlutterContacts.getContact(
      picked.id,
      withProperties: true,
    );

    print("Full contact phones: ${fullContact?.phones}");

    if (fullContact != null && fullContact.phones.isNotEmpty) {
      setState(() {
        if (!contacts.any((c) => c.id == fullContact.id)) {
          contacts.add(fullContact);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected contact has no phone number")),
      );
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

  String hashPhone(String phone) {
    final bytes = utf8.encode(phone);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> registerOnBlockchain(String phone, String cid) async {
    final phoneHash = hashPhone(phone);

    final contract = DeployedContract(
      ContractAbi.fromJson(abiJson, "UserRegistry"),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = contract.function("registerUser");

    final credentials = EthPrivateKey.fromHex("YOUR_PRIVATE_KEY");

    await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [phoneHash, cid],
      ),
      chainId: 11155111, // Sepolia
    );
  }

  Future<String?> uploadFullProfile(UserRegistration user) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6:3000/upload-json"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["cid"];
      } else {
        return null;
      }
    } catch (e) {
      print("JSON upload error: $e");
      return null;
    }
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
                          "Step 4 of 4  •  Safety Setup",
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

                const SizedBox(height: 18),

                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_accent, Color(0xFF7C93F8)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        contact.phones.first.number,
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
                                      contacts.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),

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

                _nextButton(() async {
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

                  // ✅ Save contacts into user model
                  widget.user.emergencyContacts = contacts.map((c) {
                    return {
                      "name": c.displayName,
                      "phone": c.phones.first.number,
                    };
                  }).toList();

                  try {
                    // 🚀 Upload full profile JSON to backend
                    final profileCid = await uploadFullProfile(widget.user);

                    if (profileCid == null) {
                      throw Exception("Profile upload failed");
                    }

                    // 🔐 Call smart contract
                    await registerOnBlockchain(widget.user.phone!, profileCid);

                    // 🎉 Success
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectStatePage(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
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
