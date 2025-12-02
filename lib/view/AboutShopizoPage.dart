import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecommerce/utils/color_const.dart';

class AboutShopizoPage extends StatelessWidget {
  const AboutShopizoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'About Shopizo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Tagline
            Center(
              child: Column(
                children: [
                  Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: backGroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset("assets/images/logo.png")),
                  const SizedBox(height: 20),
                  const Text(
                    'Shopizo',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Trusted Shopping Companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // About Section
            _buildSectionTitle('About Our App'),
            const SizedBox(height: 12),
            _buildParagraph(
                'Shopizo is a cutting-edge ecommerce mobile application designed to provide '
                'a seamless shopping experience. Our platform connects buyers with a wide '
                'range of products, from electronics to fashion, all at your fingertips.'),

            const SizedBox(height: 30),

            // Key Features
            _buildSectionTitle('Key Features'),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.security,
              title: 'Secure Shopping',
              description:
                  'End-to-end encryption and secure payment processing',
            ),
            _buildFeatureItem(
              icon: Icons.local_shipping,
              title: 'Fast Delivery',
              description: 'Quick shipping with real-time tracking',
            ),
            _buildFeatureItem(
              icon: Icons.support_agent,
              title: '24/7 Support',
              description: 'Round-the-clock customer service',
            ),
            _buildFeatureItem(
              icon: Icons.verified_user,
              title: 'Authentic Products',
              description: '100% genuine products with warranty',
            ),

            const SizedBox(height: 30),

            // Our Mission
            _buildSectionTitle('Our Mission'),
            const SizedBox(height: 12),
            _buildParagraph(
                'To revolutionize online shopping by creating an intuitive, secure, '
                'and enjoyable platform that empowers both buyers and sellers, '
                'making quality products accessible to everyone.'),

            const SizedBox(height: 30),

            // Statistics
            _buildSectionTitle('Shopizo in Numbers'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('20+', 'Products'),
                // _buildStatItem('500+', 'Sellers'),
                _buildStatItem('50+', 'Customers'),
              ],
            ),

            const SizedBox(height: 30),

            // Contact Section
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 12),
            _buildContactItem(
              Icons.email,
              'Email',
              'shopizo@protonmail.com',
              () => _launchEmail('shopizo@protonmail.com'),
            ),
            _buildContactItem(
              Icons.phone,
              'Phone',
              '+977 9869413778',
              () => _launchPhone('+9779869413778'),
            ),
            _buildContactItem(
              Icons.location_on,
              'Address',
              'Tindobato, Banepa',
              () => _launchMaps('Tindobato, Banepa'),
            ),

            const SizedBox(height: 30),

            // Social Media
            _buildSectionTitle('Follow Us'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.facebook,
                    () => _launchURL('https://facebook.com/shopizo')),
                const SizedBox(width: 20),
                _buildSocialIcon(Icons.camera_alt,
                    () => _launchURL('https://instagram.com/shopizo')),
                const SizedBox(width: 20),
                _buildSocialIcon(
                    Icons.web, () => _launchURL('https://twitter.com/shopizo')),
                const SizedBox(width: 20),
                _buildSocialIcon(Icons.linked_camera,
                    () => _launchURL('https://linkedin.com/company/shopizo')),
              ],
            ),

            const SizedBox(height: 30),

            // App Version
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Version',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Version 2.1.0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '© 2025 Shopizo',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Terms and Privacy
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _showTerms(context),
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => _showPrivacy(context),
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
        height: 1.6,
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C63FF)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backGroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF6C63FF)),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (!await launchUrl(emailUri)) {
      debugPrint('Could not launch $emailUri');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (!await launchUrl(phoneUri)) {
      debugPrint('Could not launch $phoneUri');
    }
  }

  Future<void> _launchMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final Uri mapsUri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (!await launchUrl(mapsUri)) {
      debugPrint('Could not launch $mapsUri');
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $uri');
    }
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Text(
            'Welcome to Shopizo! These terms and conditions outline the rules and regulations for the use of Shopizo\'s Mobile Application...',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. This privacy policy explains what personal data we collect and how we use it...',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
