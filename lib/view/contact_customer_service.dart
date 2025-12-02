import 'package:ecommerce/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCustomerServicePage extends StatelessWidget {
  const ContactCustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Customer Service'),
        centerTitle: true,
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: 'shopizo@protonmail.com',
              onTap: () => _launchEmail('shopizo@protonmail.com'),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '+977 9869413778',
              onTap: () => _launchPhone('+9779869413778'),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.location_on,
              title: 'Address',
              value: 'Tindobato, Banepa',
              onTap: () => _launchMaps('Tindobato, Banepa'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUrl = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUrl = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    }
  }

  Future<void> _launchMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final Uri mapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(mapsUrl)) {
      await launchUrl(mapsUrl);
    }
  }
}
