import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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

  static const List<String> _welcomeWords = [
    'Welcome',
    'स्वागत है',
    'ਸੁਆਗਤ ਹੈ',
    'સ્વાગત છે',
    'স্বাগতম',
    'ಸ್ವಾಗತ',
    'സ്വാഗതം',
    'வரவேற்கிறோம்',
    'స్వాగతం',
    'स्वागतम्',
  ];

  @override
  void dispose() {
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
                            child: AnimatedTextKit(
                              animatedTexts: _welcomeWords.map((word) =>
                                TypewriterAnimatedText(
                                  word,
                                  textStyle: GoogleFonts.dancingScript(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  speed: const Duration(milliseconds: 120),
                                  cursor: '|',
                                ),
                              ).toList(),
                              repeatForever: true,
                              pause: const Duration(milliseconds: 1800),
                              displayFullTextOnTap: false,
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
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('+91', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
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

