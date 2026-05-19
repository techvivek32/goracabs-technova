import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();

  bool _agreedToPolicy = false;

  File? _profilePhoto;
  File? _idPhoto;
  final _picker = ImagePicker();

  Future<void> _pickProfilePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _profilePhoto = File(picked.path));
  }

  Future<void> _captureIdPhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (picked != null) setState(() => _idPhoto = File(picked.path));
  }

  void _showPrivacyPolicy() {
    bool tempAgreed = _agreedToPolicy;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: const Text(
                            'Last updated: January 2025\n\n'
                            '1. Information We Collect\n'
                            'We collect information you provide directly to us, such as your name, phone number, email address, city, and ID proof when you create an account.\n\n'
                            '2. How We Use Your Information\n'
                            'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, and respond to your comments and questions.\n\n'
                            '3. Sharing of Information\n'
                            'We do not share your personal information with third parties except as described in this policy. We may share your information with drivers to facilitate your ride bookings.\n\n'
                            '4. Data Security\n'
                            'We take reasonable measures to help protect information about you from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction.\n\n'
                            '5. Location Information\n'
                            'We collect location information when you use our app to provide ride services. You can disable location access in your device settings, but this may affect app functionality.\n\n'
                            '6. Your Rights\n'
                            'You have the right to access, update, or delete your personal information at any time through the app settings or by contacting our support team.\n\n'
                            '7. Contact Us\n'
                            'If you have any questions about this Privacy Policy, please contact us at support@goracabs.com.',
                            style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: tempAgreed,
                            activeColor: AppTheme.primaryBlue,
                            onChanged: (val) => setModalState(() => tempAgreed = val ?? false),
                          ),
                          const Expanded(
                            child: Text('I have read and agree to the Privacy Policy',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: tempAgreed
                              ? () {
                                  setState(() => _agreedToPolicy = true);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Agree & Continue'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showPrivacyPolicyText() => _showPrivacyPolicy();

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
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

          // Foreground
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Profile photo picker
                        GestureDetector(
                          onTap: _pickProfilePhoto,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            backgroundImage: _profilePhoto != null ? FileImage(_profilePhoto!) : null,
                            child: _profilePhoto == null
                                ? const Icon(Icons.add_a_photo, size: 32, color: AppTheme.primaryBlue)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Profile Photo',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                        ),

                        const SizedBox(height: 24),

                        // White card
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
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),

                              _buildLabel('Full Name'),
                              _buildField(
                                controller: _nameController,
                                hint: 'Enter your full name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),

                              _buildLabel('City'),
                              _buildField(
                                controller: _cityController,
                                hint: 'Enter your city',
                                icon: Icons.location_city_outlined,
                              ),
                              const SizedBox(height: 16),

                              _buildLabel('Phone Number'),
                              _buildField(
                                controller: _phoneController,
                                hint: 'Enter your phone number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                showPrefix: true,
                              ),
                              const SizedBox(height: 16),

                              _buildLabel('Mail ID'),
                              _buildField(
                                controller: _emailController,
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),

                              _buildLabel('ID Number'),
                              _buildField(
                                controller: _idNumberController,
                                hint: 'Enter your ID number',
                                icon: Icons.badge_outlined,
                              ),
                              const SizedBox(height: 16),

                              _buildLabel('ID Proof (Real-time capture)'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _captureIdPhoto,
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[50],
                                    image: _idPhoto != null
                                        ? DecorationImage(image: FileImage(_idPhoto!), fit: BoxFit.cover)
                                        : null,
                                  ),
                                  child: _idPhoto == null
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt_outlined, size: 32, color: AppTheme.primaryBlue),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap to capture ID',
                                              style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Privacy Policy checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreedToPolicy,
                                    activeColor: AppTheme.primaryBlue,
                                    onChanged: (_) => _showPrivacyPolicy(),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _showPrivacyPolicy,
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(color: Colors.black87, fontSize: 13),
                                          children: [
                                            const TextSpan(text: 'I agree to the '),
                                            TextSpan(
                                              text: 'Privacy Policy',
                                              style: TextStyle(
                                                color: AppTheme.primaryBlue,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _agreedToPolicy
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const OtpScreen()),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: const Text('Create Account'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool showPrefix = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: showPrefix
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('+91', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              )
            : Icon(icon),
        prefixIconConstraints: showPrefix ? const BoxConstraints(minWidth: 0, minHeight: 0) : null,
      ),
    );
  }
}
