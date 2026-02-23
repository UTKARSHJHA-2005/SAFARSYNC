import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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

  @override
  void initState() {
    super.initState();

    nameController.text = "Rahul Sharma";
    blockchainController.text = "0xA67B98F23C";
    phoneController.text = "+91 9876543210";
    emergencyControllers = [
      TextEditingController(text: "+91 9123456789"),
      TextEditingController(text: "+91 9988776655"),
    ];
    bloodController.text = "O+";
    medicationController.text = "None";
    addressController.text = "Guwahati, Assam, India";
    isOrganDonor = true;

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
                  vertical: 24,
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
                        ),
                        const Text(
                          "My Profile",
                          style: TextStyle(
                            color: Color.fromARGB(255, 80, 80, 247),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        _glassIconButton(
                          Icons.more_horiz_rounded,
                          Colors.blueAccent,
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

                        /// Avatar
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/p1.jpg"),
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

                    /// Name & blockchain badge
                    Text(
                      nameController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _blockchainBadge(blockchainController.text),

                    const SizedBox(height: 28),

                    /// ── STAT CHIPS ────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statChip(
                          Icons.bloodtype_rounded,
                          "Blood",
                          bloodController.text,
                          const Color(0xFFef4444),
                        ),
                        const SizedBox(width: 12),
                        _statChip(
                          Icons.favorite_rounded,
                          "Organ\nDonor",
                          isOrganDonor ? "Yes ✓" : "No",
                          const Color(0xFF10b981),
                        ),
                        const SizedBox(width: 12),
                        _statChip(
                          Icons.location_on_rounded,
                          "City",
                          "Guwahati",
                          const Color(0xFF3b82f6),
                        ),
                      ],
                    ),

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

                    /// ── SECTION: Blockchain Identity ──────────────────────
                    _sectionCard(
                      icon: Icons.link_rounded,
                      title: "Blockchain Identity",
                      color: const Color(0xFF4f46e5),
                      children: [
                        _styledField(
                          label: "Blockchain ID",
                          controller: blockchainController,
                          icon: Icons.fingerprint_rounded,
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

                    const SizedBox(height: 16),

                    /// ── SECTION: Medical Info ─────────────────────────────
                    _sectionCard(
                      icon: Icons.medical_information_rounded,
                      title: "Medical Info",
                      color: const Color(0xFF10b981),
                      children: [
                        _styledField(
                          label: "Blood Type",
                          controller: bloodController,
                          icon: Icons.bloodtype_rounded,
                        ),
                        _styledField(
                          label: "Medications",
                          controller: medicationController,
                          icon: Icons.medication_rounded,
                        ),

                        /// Organ Donor Toggle
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10b981).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF10b981).withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10b981,
                                  ).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.volunteer_activism_rounded,
                                  color: Color(0xFF10b981),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Organ Donor",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1e293b),
                                      ),
                                    ),
                                    Text(
                                      "Registered for organ donation",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748b),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Switch(
                                  value: isOrganDonor,
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFF10b981),
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: const Color(0xFFcbd5e1),
                                  onChanged: (v) =>
                                      setState(() => isOrganDonor = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _glassIconButton(IconData icon, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white.withOpacity(0.18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 18),
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
            text,
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
