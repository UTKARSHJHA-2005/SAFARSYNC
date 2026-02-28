import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:safarsync/components/most.dart';
import 'package:safarsync/Profile.dart';
import 'package:safarsync/components/input.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:safarsync/model/user_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool otpVerified = false;
  String generatedOtp = "";
  String? selectedSex;

  late AnimationController _slideController;
  late AnimationController _otpController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _otpSlideAnimation;
  late Animation<double> _otpFadeAnimation;

  @override
  void initState() {
    super.initState();
    user = UserRegistration();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _otpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _otpSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _otpController, curve: Curves.easeOutCubic),
        );

    _otpFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _otpController, curve: Curves.easeOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    otpController.dispose();
    _slideController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  static const Color _ink = Color(0xFF1A1A2E);
  static const Color _accent = Color(0xFF4F6EF7);
  static const Color _accentLight = Color(0xFFEEF1FF);
  static const Color _success = Color(0xFF22C55E);
  static const Color _surface = Colors.white;
  static const Color _muted = Color(0xFF8A8FA8);
  static const Color _border = Color(0xFFE8EAF2);
  InputDecoration _fieldDec(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _muted,
        fontSize: 14,
        fontFamily: 'Georgia',
      ),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: _muted) : null,
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
    );
  }

  InputDecoration _dropdownDec() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _ink,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _sectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [Expanded(child: Container(height: 1, color: _border))],
      ),
    );
  }

  Widget _stepBadge(int step) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '$step',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sendOtpButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (phoneController.text.length >= 10) {
            setState(() {
              generatedOtp = (1000 + (DateTime.now().millisecond % 9000))
                  .toString();
              otpSent = true;
            });
            _otpController.forward(from: 0);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("OTP Sent: $generatedOtp"),
                backgroundColor: _accent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Send OTP",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _verifyOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          if (otpController.text == generatedOtp) {
            setState(() => otpVerified = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text("Phone verified successfully!"),
                  ],
                ),
                backgroundColor: _success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text("Invalid OTP. Please try again."),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: otpVerified ? _success : const Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              otpVerified ? Icons.verified_outlined : Icons.lock_open_outlined,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              otpVerified ? "Verified ✓" : "Verify OTP",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
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

  late UserRegistration user;

  String? selectedCountry;
  String selectedDialCode = "+91";

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 52),

                      // ── Header ──────────────────────────────────────────
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
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E),
                                  letterSpacing: -0.5,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Step 1 of 4  •  Personal Details",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _ink.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Progress bar
                      Container(
                        margin: const EdgeInsets.only(top: 18, bottom: 24),
                        height: 4,
                        decoration: BoxDecoration(
                          color: _border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.2,
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

                      // ── Main Card ───────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F6EF7).withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Section: Identity ──────────────────────
                            Row(
                              children: [
                                _stepBadge(1),
                                const SizedBox(width: 10),
                                const Text(
                                  "Identity",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: _ink,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            _label("Full Name"),
                            TextFormField(
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 14,
                                color: _ink,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: _fieldDec(
                                "e.g. Arjun Mehta",
                                icon: Icons.person_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Full name is required";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Age + Sex in a row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label("Age"),
                                      TextFormField(
                                        controller: ageController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: _ink,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: _fieldDec(
                                          "e.g. 25",
                                          icon: Icons.cake_outlined,
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label("Gender"),
                                      DropdownButtonFormField<String>(
                                        decoration: _dropdownDec(),
                                        value: selectedSex,
                                        hint: const Text(
                                          "Select",
                                          style: TextStyle(
                                            color: _muted,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: _ink,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: _muted,
                                        ),
                                        dropdownColor: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Male",
                                            child: Text("Male"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Female",
                                            child: Text("Female"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Lesbian",
                                            child: Text("Lesbian"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Gay",
                                            child: Text("Gay"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Other",
                                            child: Text("Other"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedSex = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _label("Country"),

                            CountryListPick(
                              appBar: AppBar(
                                backgroundColor: _accent,
                                title: const Text("Select Country"),
                              ),
                              theme: CountryTheme(
                                isShowFlag: true,
                                isShowTitle: true,
                                isShowCode: false,
                                isDownIcon: true,
                                showEnglishName: true,
                              ),
                              initialSelection: '+91',
                              onChanged: (CountryCode? code) {
                                setState(() {
                                  selectedCountry = code?.name;
                                  selectedDialCode = code?.dialCode ?? "+91";
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            _sectionDivider(),

                            // ── Section: Phone Verification ─────────────
                            Row(
                              children: [
                                _stepBadge(2),
                                const SizedBox(width: 10),
                                const Text(
                                  "Phone Verification",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: _ink,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const Spacer(),
                                if (otpVerified)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 13,
                                          color: _success,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Verified",
                                          style: TextStyle(
                                            color: _success,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            _label("Phone Number"),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: _ink,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: _fieldDec("00000 00000")
                                        .copyWith(
                                          prefixIcon: Container(
                                            width: 70,
                                            alignment: Alignment.center,
                                            child: Text(
                                              selectedDialCode,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: _ink,
                                              ),
                                            ),
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Phone number is required";
                                      }
                                      if (value.length < 10) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _sendOtpButton(),
                              ],
                            ),

                            // ── OTP Section ─────────────────────────────
                            if (otpSent) ...[
                              const SizedBox(height: 16),
                              SlideTransition(
                                position: _otpSlideAnimation,
                                child: FadeTransition(
                                  opacity: _otpFadeAnimation,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: _accentLight,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.info_outline_rounded,
                                              size: 16,
                                              color: _accent,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "OTP sent to ${phoneController.text}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: _accent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      _label("Enter OTP"),
                                      TextFormField(
                                        controller: otpController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: _ink,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 12,
                                        ),
                                        decoration: _fieldDec("• • • •")
                                            .copyWith(
                                              counterText: "",
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      _verifyOtpButton(),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            // ── Terms ────────────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _border),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color: _muted,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _muted,
                                          height: 1.5,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                "By continuing, you agree to our ",
                                          ),
                                          TextSpan(
                                            text: "Terms of Service",
                                            style: TextStyle(
                                              color: _accent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: _accent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: "."),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Next Button ─────────────────────────────────────
                      _nextButton(() async {
                        if (_formKey.currentState!.validate()) {
                          if (!otpVerified) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Please verify your phone number first",
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFFF59E0B),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }

                          // ✅ SAVE DATA INTO MODEL
                          user.name = nameController.text.trim();
                          user.age = int.parse(ageController.text.trim());
                          user.gender = selectedSex;
                          user.country = selectedCountry;
                          user.phone =
                              "$selectedDialCode${phoneController.text.trim()}";
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("userPhone", user.phone!);

                          // 🚀 Move to Step 2 WITH DATA
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RegisterStep2(user: user),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SlideTransition(
                                      position:
                                          Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutCubic,
                                            ),
                                          ),
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        }
                      }),
                      const SizedBox(height: 24),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
