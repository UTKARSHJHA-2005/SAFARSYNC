import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'dart:convert';
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
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  List<TextEditingController> emergencyControllers = [];
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  List<String> interests = [];
  bool isOrganDonor = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  /// ── IMPORTANT: The server hashes phone using ethers.keccak256.
  /// We cannot replicate keccak256 in plain Dart without a web3 library,
  /// so instead we send the raw phone to a dedicated backend endpoint
  /// that performs the hash server-side. This keeps hashing logic in one place.
  Future<String?> _fetchCidForPhone(String rawPhone) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.5:3000/get-profile-by-phone"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": rawPhone}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["cid"] as String?;
    }
    return null;
  }

  Future<void> fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userPhone = prefs.getString("userPhone");

      if (userPhone == null) {
        setState(() {
          _errorMessage = "Not logged in.";
          _isLoading = false;
        });
        return;
      }

      // 1️⃣ Get CID from backend (backend does keccak256 hashing)
      final cid = await _fetchCidForPhone(userPhone);

      if (cid == null || cid.isEmpty) {
        setState(() {
          _errorMessage = "No profile found on blockchain.";
          _isLoading = false;
        });
        return;
      }

      // 2️⃣ Fetch JSON from IPFS via Pinata gateway
      final ipfsResponse = await http.get(
        Uri.parse("https://gateway.pinata.cloud/ipfs/$cid"),
      );

      if (ipfsResponse.statusCode != 200) {
        setState(() {
          _errorMessage = "Failed to load profile data from IPFS.";
          _isLoading = false;
        });
        return;
      }

      final data = jsonDecode(ipfsResponse.body) as Map<String, dynamic>;

      // 3️⃣ Populate UI
      setState(() {
        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        ageController.text = data["age"]?.toString() ?? "";
        genderController.text = data["gender"] ?? "";
        countryController.text = data["country"] ?? "";
        summaryController.text = data["summary"] ?? "";
        blockchainController.text = cid;

        // photo is stored as a CID — build the full gateway URL
        final rawPhoto = data["photo"] as String?;
        if (rawPhoto != null && rawPhoto.isNotEmpty) {
          // Support both full URLs (legacy) and raw CIDs
          if (rawPhoto.startsWith("http")) {
            profilePhotoUrl = rawPhoto;
          } else {
            profilePhotoUrl = "https://gateway.pinata.cloud/ipfs/$rawPhoto";
          }
        }

        // Interests
        interests = List<String>.from(data["interests"] ?? []);

        // Emergency contacts
        for (var c in emergencyControllers) {
          c.dispose();
        }
        emergencyControllers =
            (data["emergencyContacts"] as List<dynamic>? ?? [])
                .map<TextEditingController>(
                  (e) => TextEditingController(
                    text: "${e["name"] ?? ""} — ${e["phone"] ?? ""}",
                  ),
                )
                .toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading profile: $e";
        _isLoading = false;
      });
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
    ageController.dispose();
    genderController.dispose();
    summaryController.dispose();
    for (var c in emergencyControllers) {
      c.dispose();
    }
    bloodController.dispose();
    countryController.dispose();
    super.dispose();
  }

  // ── Save: re-upload updated JSON to IPFS and update blockchain ──────────
  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userPhone = prefs.getString("userPhone");
      if (userPhone == null) throw Exception("Not logged in");

      // Build updated profile JSON
      final updatedProfile = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "age": int.tryParse(ageController.text.trim()),
        "gender": genderController.text.trim(),
        "country": countryController.text.trim(),
        "summary": summaryController.text.trim(),
        "photo": profilePhotoUrl ?? "",
        "interests": interests,
        // Keep emergency contacts read-only on this page for safety
        "emergencyContacts": [],
      };

      // 1️⃣ Upload updated JSON to Pinata
      final uploadResponse = await http.post(
        Uri.parse("http://192.168.1.5:3000/upload-json"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedProfile),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception("Failed to upload updated profile");
      }

      final newCid = jsonDecode(uploadResponse.body)["cid"] as String;

      // 2️⃣ Update CID on blockchain via backend
      final updateResponse = await http.post(
        Uri.parse("http://192.168.1.5:3000/update-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": userPhone, "newCID": newCid}),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception("Blockchain update failed");
      }

      setState(() {
        blockchainController.text = newCid;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile saved to blockchain ✓"),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Save failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _errorMessage != null
                  ? _buildError()
                  : _buildProfile(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 56),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4f46e5),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // ── TOP BAR ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _glassIconButton(
                Icons.arrow_back_ios_new_rounded,
                Colors.blueAccent,
                onPressed: () => Navigator.pop(context),
              ),
              _glassIconButton(
                Icons.refresh_rounded,
                Colors.white70,
                onPressed: fetchProfile,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── AVATAR ───────────────────────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
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
                      color: const Color(0xFF6366f1).withOpacity(0.55),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
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
                    profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty
                    ? NetworkImage(profilePhotoUrl!) as ImageProvider
                    : const AssetImage("assets/p1.jpg"),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7c3aed), Color(0xFF4f46e5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7c3aed).withOpacity(0.5),
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
            ],
          ),

          const SizedBox(height: 14),

          Text(
            nameController.text.isEmpty ? "Loading..." : nameController.text,
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

          const SizedBox(height: 6),
          _blockchainBadge(blockchainController.text),
          const SizedBox(height: 28),

          // ── SECTION: Personal Info ────────────────────────────────────────
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
              Row(
                children: [
                  Expanded(
                    child: _styledField(
                      label: "Age",
                      controller: ageController,
                      icon: Icons.cake_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _styledField(
                      label: "Gender",
                      controller: genderController,
                      icon: Icons.wc_rounded,
                    ),
                  ),
                ],
              ),
              _styledField(
                label: "Country",
                controller: countryController,
                icon: Icons.public_rounded,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── SECTION: About ────────────────────────────────────────────────
          _sectionCard(
            icon: Icons.auto_stories_rounded,
            title: "About Me",
            color: const Color(0xFF0ea5e9),
            children: [
              _styledField(
                label: "Bio / Summary",
                controller: summaryController,
                icon: Icons.format_quote_rounded,
                maxLines: 4,
              ),
              if (interests.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: interests
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0ea5e9).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: const Color(0xFF0ea5e9).withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0c4a6e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // ── SECTION: Emergency Contacts ───────────────────────────────────
          _sectionCard(
            icon: Icons.emergency_rounded,
            title: "Emergency Contacts",
            color: const Color(0xFFef4444),
            children: emergencyControllers.isEmpty
                ? [
                    Text(
                      "No emergency contacts found",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ]
                : List.generate(
                    emergencyControllers.length,
                    (i) => _styledField(
                      label: "Contact ${i + 1}",
                      controller: emergencyControllers[i],
                      icon: Icons.contact_phone_rounded,
                      keyboardType: TextInputType.phone,
                      readOnly: true, // contacts are set at registration
                    ),
                  ),
          ),

          const SizedBox(height: 28),

          // ── SAVE BUTTON ───────────────────────────────────────────────────
          GestureDetector(
            onTap: _isSaving ? null : _saveProfile,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: _isSaving
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : [const Color(0xFF7c3aed), const Color(0xFF4f46e5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: _isSaving
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFF7c3aed).withOpacity(0.45),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isSaving)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons.cloud_upload_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  const SizedBox(width: 10),
                  Text(
                    _isSaving ? "Saving..." : "Save Profile",
                    style: const TextStyle(
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
    );
  }

  // ── HELPERS ────────────────────────────────────────────────────────────────

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
            text.isEmpty
                ? "Not on blockchain"
                : text.length > 16
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
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
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
          fillColor: readOnly
              ? const Color(0xFFF0F0F8)
              : const Color(0xFFF8FAFF),
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
