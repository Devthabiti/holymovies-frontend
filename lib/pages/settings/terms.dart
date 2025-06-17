import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
      ),
      backgroundColor: const Color(0xff121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Terms of Service",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "By using the Holy Movie app, you agree to be bound by these terms and conditions. Please read them carefully before accessing or using the app.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "1. Use of the App",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "- You must be at least 13 years old to use this app.\n"
              "- You agree not to misuse the app or engage in any illegal activities through it.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "2. Content Ownership",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "All content provided through the app is either owned by Holy Movie or licensed for use. You may not reproduce, distribute, or sell any content without permission.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "3. Account and Security",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "4. Changes to Terms",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We may update these Terms of Service at any time. Continued use of the app indicates your acceptance of the new terms.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              "5. Termination",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We reserve the right to suspend or terminate your access to the app if you violate any of these terms.",
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
              "If you have any questions about these Terms, please contact us via the Help & Support section in the app.",
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
