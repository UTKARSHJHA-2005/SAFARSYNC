import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController blockchainController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  List<TextEditingController> emergencyControllers = [];
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isOrganDonor = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String hashPhone(String phone) {
    return sha256.convert(utf8.encode(phone)).toString();
  }

  Future<void> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userPhone = prefs.getString("userPhone");

      if (userPhone == null) {
        print("User not logged in");
        return;
      }

      // 1️⃣ Get CID from backend
      final response = await http.get(
        Uri.parse("http://192.168.1.5:3000/get-profile/$userPhone"),
      );

      if (response.statusCode != 200) {
        print("Failed to fetch CID");
        return;
      }

      final cid = jsonDecode(response.body)["cid"];

      if (cid == null || cid.isEmpty) {
        print("No CID found");
        return;
      }

      // 2️⃣ Fetch JSON from IPFS
      final ipfsResponse = await http.get(
        Uri.parse("https://gateway.pinata.cloud/ipfs/$cid"),
      );

      if (ipfsResponse.statusCode != 200) {
        print("Failed to fetch IPFS data");
        return;
      }

      final data = jsonDecode(ipfsResponse.body);

      // 3️⃣ Populate UI safely
      setState(() {
        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        bloodController.text = data["bloodType"] ?? "";
        medicationController.text = data["medications"] ?? "";
        addressController.text = data["country"] ?? "";
        profilePhotoUrl = data["photo"];
        blockchainController.text = cid;

        // Clear old controllers first
        for (var c in emergencyControllers) {
          c.dispose();
        }

        emergencyControllers =
            (data["emergencyContacts"] as List<dynamic>? ?? [])
                .map<TextEditingController>(
                  (e) => TextEditingController(text: e["phone"] ?? ""),
                )
                .toList();
      });
    } catch (e) {
      print("Profile fetch error: $e");
    }
  }

  String? profilePhotoUrl;

  @override
  void initState() {
    super.initState();

    fetchProfile();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    nameController.dispose();
    blockchainController.dispose();
    phoneController.dispose();
    for (var c in emergencyControllers) {
      c.dispose();
    }
    bloodController.dispose();
    medicationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    /// ── TOP BAR ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _glassIconButton(
                          Icons.arrow_back_ios_new_rounded,
                          Colors.blueAccent,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// ── AVATAR HERO ───────────────────────────────────────
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Glow ring
                        Container(
                          width: 138,
                          height: 138,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const SweepGradient(
                              colors: [
                                Color(0xFFa855f7),
                                Color(0xFF6366f1),
                                Color(0xFF06b6d4),
                                Color(0xFFa855f7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6366f1,
                                ).withOpacity(0.55),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        /// White border
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),

                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              profilePhotoUrl != null &&
                                  profilePhotoUrl!.isNotEmpty
                              ? NetworkImage(profilePhotoUrl!)
                              : const AssetImage("assets/p1.jpg")
                                    as ImageProvider,
                        ),

                        /// Edit badge
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7c3aed),
                                    Color(0xFF4f46e5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7c3aed,
                                    ).withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Column(
                      children: [
                        Text(
                          nameController.text.isEmpty
                              ? "Loading..."
                              : nameController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: Colors.greenAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              phoneController.text,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _blockchainBadge(blockchainController.text),
                    const SizedBox(height: 28),

                    /// ── SECTION: Personal Info ────────────────────────────
                    _sectionCard(
                      icon: Icons.person_rounded,
                      title: "Personal Info",
                      color: const Color(0xFF7c3aed),
                      children: [
                        _styledField(
                          label: "Full Name",
                          controller: nameController,
                          icon: Icons.badge_rounded,
                        ),
                        _styledField(
                          label: "Phone Number",
                          controller: phoneController,
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                        ),
                        _styledField(
                          label: "Address",
                          controller: addressController,
                          icon: Icons.home_rounded,
                          maxLines: 2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// ── SECTION: Emergency Contacts ───────────────────────
                    _sectionCard(
                      icon: Icons.emergency_rounded,
                      title: "Emergency Contacts",
                      color: const Color(0xFFef4444),
                      children: List.generate(
                        emergencyControllers.length,
                        (i) => _styledField(
                          label: "Contact ${i + 1}",
                          controller: emergencyControllers[i],
                          icon: Icons.contact_phone_rounded,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    /// ── SAVE BUTTON ───────────────────────────────────────
                    GestureDetector(
                      onTap: () {
                        // save logic
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7c3aed), Color(0xFF4f46e5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7c3aed).withOpacity(0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Save Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────

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

  Widget _blockchainBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_rounded, color: Colors.white70, size: 14),
          const SizedBox(width: 6),
          Text(
            text.length > 16
                ? "${text.substring(0, 10)}...${text.substring(text.length - 4)}"
                : text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.93),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _styledField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1e293b),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF94a3b8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, size: 19, color: const Color(0xFFa0aec0)),
          filled: true,
          fillColor: const Color(0xFFF8FAFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFe2e8f0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7c3aed), width: 2),
          ),
        ),
      ),
    );
  }
}
