import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        //title: const Text("About Us"),
        backgroundColor: const Color(0xff121212),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Holy Movie",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your ultimate source for uplifting, Christian, and inspirational movies — anytime, anywhere.",
              style:
                  TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 24),
            const Text(
              "Our Mission",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We aim to bring hope, values, and spiritual growth through film. Holy Movie is more than entertainment — it's a ministry through media.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "📧 holymoviestz@gmail.com\n📱 +255 710 070 820 \n🌐 @holymovies_tz on all platforms",
              style:
                  TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            Center(
              child: Text(
                "© ${DateTime.now().year} Holy Movie. All rights reserved.",
                style: const TextStyle(color: Color(0xffB3B3B3), fontSize: 13),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
