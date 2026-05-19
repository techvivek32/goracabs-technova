import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import 'signup_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // Indian language welcome words
  static const List<String> _welcomeWords = [
    'Welcome',       // English (used in India)
    'स्वागत है',      // Hindi
    'ਸੁਆਗਤ ਹੈ',      // Punjabi
    'સ્વાગત છે',      // Gujarati
    'স্বাগতম',        // Bengali
    'ಸ್ವಾಗತ',         // Kannada
    'സ്വാഗതം',        // Malayalam
    'வரவேற்கிறோம்',   // Tamil
    'స్వాగతం',        // Telugu
    'स्वागतम्',       // Sanskrit/Marathi
  ];

  int _wordIndex = 0;
  String _displayedText = '';
  bool _isTyping = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    _typeNextChar();
  }

  void _typeNextChar() {
    final fullWord = _welcomeWords[_wordIndex];

    if (_isTyping) {
      if (_displayedText.length < fullWord.length) {
        _timer = Timer(const Duration(milliseconds: 80), () {
          if (!mounted) return;
          setState(() {
            _displayedText = fullWord.substring(0, _displayedText.length + 1);
          });
          _typeNextChar();
        });
      } else {
        // Pause before erasing
        _timer = Timer(const Duration(milliseconds: 1200), () {
          if (!mounted) return;
          setState(() => _isTyping = false);
          _typeNextChar();
        });
      }
    } else {
      if (_displayedText.isNotEmpty) {
        _timer = Timer(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          setState(() {
            _displayedText = _displayedText.substring(0, _displayedText.length - 1);
          });
          _typeNextChar();
        });
      } else {
        // Move to next word
        setState(() {
          _wordIndex = (_wordIndex + 1) % _welcomeWords.length;
          _isTyping = true;
        });
        _typeNextChar();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image with Opacity Gradient
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(26),
                    Colors.black.withAlpha(102),
                    Colors.black.withAlpha(102),
                    Colors.black.withAlpha(26),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/123456789.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 1),

                          // Typewriter welcome text
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _displayedText,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // Blinking cursor
                                _BlinkingCursor(),
                              ],
                            ),
                          ),

                          const Spacer(flex: 1),

                          // BOTTOM SECTION: White card with rounded top corners
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your phone number',
                                    prefixText: '+91 ',
                                    prefixStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const OtpScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('Send OTP'),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.grey[300])),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('OR', style: TextStyle(color: Colors.grey[500])),
                                    ),
                                    Expanded(child: Divider(color: Colors.grey[300])),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialButton(
                                        icon: FontAwesomeIcons.google,
                                        color: Colors.white,
                                        textColor: Colors.black87,
                                        borderColor: Colors.grey[300],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialButton(
                                        icon: FontAwesomeIcons.apple,
                                        color: Colors.black,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                                        );
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
  }) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: FaIcon(icon, size: 24, color: textColor),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Text(
        '|',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }
}
