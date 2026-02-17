import 'package:flutter/material.dart';
import 'package:safarsync/components/gradient.dart';
import 'package:safarsync/components/most.dart';

class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({super.key});

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3>
    with TickerProviderStateMixin {
  final TextEditingController aboutController = TextEditingController();
  int _charCount = 0;
  static const int _maxChars = 280;

  // Travel interest tags
  final List<String> _allTags = [
    '🏔️ Mountains',
    '🏖️ Beaches',
    '🏛️ History',
    '🍜 Food',
    '🎒 Backpacking',
    '🚂 Trains',
    '🌿 Nature',
    '🎭 Culture',
    '📸 Photography',
    '🏕️ Camping',
    '🌆 Cities',
    '🤿 Adventure',
  ];
  final Set<String> _selectedTags = {};

  late AnimationController _slideController;
  late AnimationController _successController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  bool _submitted = false;

  // ── Palette ─────────────────────────────────────────────────────────────
  static const Color _ink = Color(0xFF1A1A2E);
  static const Color _accent = Color(0xFF4F6EF7);
  static const Color _accentLight = Color(0xFFEEF1FF);
  static const Color _success = Color(0xFF22C55E);
  static const Color _surface = Colors.white;
  static const Color _muted = Color(0xFF8A8FA8);
  static const Color _border = Color(0xFFE8EAF2);

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _successScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _successFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeOut),
    );

    _slideController.forward();

    aboutController.addListener(() {
      setState(() {
        _charCount = aboutController.text.length;
      });
    });
  }

  @override
  void dispose() {
    aboutController.dispose();
    _slideController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Color get _charCountColor {
    if (_charCount > _maxChars * 0.9) return const Color(0xFFEF4444);
    if (_charCount > _maxChars * 0.7) return const Color(0xFFF59E0B);
    return _muted;
  }

  double get _charProgress => (_charCount / _maxChars).clamp(0.0, 1.0);

  void _handleSubmit() {
    if (aboutController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text("Tell us a little about yourself first"),
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

    setState(() => _submitted = true);
    _successController.forward();
  }

  // ── Success overlay ──────────────────────────────────────────────────────
  Widget _buildSuccessState() {
    return FadeTransition(
      opacity: _successFade,
      child: ScaleTransition(
        scale: _successScale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎉', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "You're all set!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Welcome to SafarSync.\nYour adventure begins now.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: _muted,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home
                },
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
                      "Start Exploring",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.explore_outlined, size: 20),
                  ],
                ),
              ),
            ),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: _submitted
                    ? _buildSuccessState()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 52),

                          // ── Header ───────────────────────────────────────
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 38,
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
                                    "Step 3 of 3 •  Your Story",
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

                          // ── Progress bar (almost full) ────────────────
                          Container(
                            margin: const EdgeInsets.only(top: 18, bottom: 24),
                            height: 4,
                            decoration: BoxDecoration(
                              color: _border,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.85,
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

                          // ── Main Card ─────────────────────────────────
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4F6EF7,
                                  ).withOpacity(0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
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
                                // ── Section: About ─────────────────────
                                Row(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: _accent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '✍️',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "About You",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: _ink,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                                const Padding(
                                  padding: EdgeInsets.only(left: 36),
                                  child: Text(
                                    "Share your travel style with future companions",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                      height: 1.4,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // Text area
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FE),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _border,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: aboutController,
                                        maxLines: 5,
                                        maxLength: _maxChars,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: _ink,
                                          height: 1.6,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          counterText: '',
                                          hintText:
                                              "e.g. Solo traveller from Mumbai. I love finding hidden cafés, hiking trails less travelled, and connecting with locals wherever I go...",
                                          hintStyle: TextStyle(
                                            color: _muted,
                                            fontSize: 13,
                                            height: 1.6,
                                          ),
                                          contentPadding: EdgeInsets.all(16),
                                        ),
                                      ),
                                      // Char counter bar
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          12,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: _charProgress,
                                                  minHeight: 3,
                                                  backgroundColor: _border,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(_charCountColor),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '$_charCount / $_maxChars',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: _charCountColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Divider
                                Container(
                                  height: 1,
                                  color: _border,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ── Section: Interests ─────────────────
                                Row(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: _accent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '🧭',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Travel Interests",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: _ink,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Optional',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                                const Padding(
                                  padding: EdgeInsets.only(left: 36),
                                  child: Text(
                                    "Pick what excites you most",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _allTags.map((tag) {
                                    final selected = _selectedTags.contains(
                                      tag,
                                    );
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selected) {
                                            _selectedTags.remove(tag);
                                          } else {
                                            _selectedTags.add(tag);
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? _accent
                                              : const Color(0xFFF8F9FE),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: selected ? _accent : _border,
                                            width: 1.5,
                                          ),
                                          boxShadow: selected
                                              ? [
                                                  BoxShadow(
                                                    color: _accent.withOpacity(
                                                      0.25,
                                                    ),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: selected
                                                ? Colors.white
                                                : _ink,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 20),

                                // Terms
                                Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAFAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: _border),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.shield_outlined,
                                        size: 15,
                                        color: _muted,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: RichText(
                                          text: const TextSpan(
                                            style: TextStyle(
                                              fontSize: 11.5,
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

                          // ── Submit button ────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
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
                                    "Complete Registration",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
