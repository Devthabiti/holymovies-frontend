import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        //title: const Text("Privacy Policy"),
        backgroundColor: const Color(0xff121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "At Holy Movie, we value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our app.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "1. Information We Collect",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "- Personal data such as name, email, or phone number.\n"
              "- Device and usage information.\n"
              "- Content interactions within the app.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "2. How We Use Your Information",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "- To provide a personalized movie experience.\n"
              "- To improve app performance and features.\n"
              "- To send notifications or updates if you opt in.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "3. Data Security",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We use industry-standard measures to protect your data, including encryption and secure storage methods.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "4. Third-Party Services",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Some services we use (e.g. analytics, ads, and payments) may collect information under their own privacy policies.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "5. Your Rights",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You may request to update or delete your personal data anytime by contacting us through the app.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "6. Contact Us",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "If you have any questions or concerns about this Privacy Policy, please contact us via the Help & Support section in the app.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "© ${DateTime.now().year} Holy Movie. All rights reserved.",
                style: const TextStyle(color: Color(0xffB3B3B3), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
