import 'dart:io';

import 'package:flutter/material.dart';
import 'package:holy/pages/settings/about.dart';
import 'package:holy/pages/settings/paid_movie.dart';
import 'package:holy/pages/settings/privacy.dart';
import 'package:holy/pages/settings/terms.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../models/providers/connectivity.dart';
import '../../models/providers/token_provider.dart';
import '../../models/services/login.dart';
import '../../models/services/utls.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh');

    if (refresh != null) {
      await http.post(
        Uri.parse('${Api.baseUrl}/logout/'),
        body: {'refresh': refresh},
      );
      await prefs.remove('token');
      await prefs
          .remove('refresh')
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false));
    }
  }

  deleteMoadal(title, desc) {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xff121212),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xffB3B3B3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 80,
                                height: 35,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffd12f26),
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color(0xffd12f26),
                                    fontSize: 14,
                                  ),
                                ))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: GestureDetector(
                            onTap: () async {
                              if (!isOnline) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                        child: Text(
                                      'No internet connection',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    )),
                                    backgroundColor: Colors.white,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                logoutUser();
                              }
                            },
                            child: Container(
                                width: 80,
                                height: 35,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    color: const Color(0xffd12f26),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                    child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    var username = context.watch<ApiCalls>().userName;
    var email = context.watch<ApiCalls>().userEmail;
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: const Color(0xff1E1E1E),
        toolbarHeight: 100,
        title: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Iconsax.profile_circle,
              color: Colors.white,
            ),
          ),
          title: Text(username,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          subtitle: Text(email,
              style: const TextStyle(color: Colors.white, fontSize: 10)),
          trailing: IconButton(
              onPressed: () {
                deleteMoadal('Logging Out', 'Are you sure you want to logout?');
              },
              icon: const Icon(
                Iconsax.logout,
                color: Colors.white,
              )),
        ),
        //actions: [IconButton(onPressed: logoutUser, icon: Icon(Icons.logout))],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff1E1E1E),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaidMovies()));
                    },
                    dense: true,
                    title: const Text(
                      'My Movies',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'General',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()));
              },
              dense: true,
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Iconsax.shield_tick,
                  size: 20,
                  color: Color(0xffd12f26),
                ),
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsOfServicePage()));
              },
              dense: true,
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Iconsax.document_text,
                  color: Color(0xffd12f26),
                  size: 20,
                ),
              ),
              title: const Text(
                'Terms of Services',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
            ListTile(
              onTap: () {
                String number = '+255710070820';
                final url = 'https://wa.me/$number';
                launchUrl(Uri.parse(url));
              },
              dense: true,
              leading: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Iconsax.message_question,
                  size: 20,
                  color: Color(0xffd12f26),
                ),
              ),
              title: const Text(
                'Help & Support',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
            ListTile(
              onTap: () {
                Platform.isAndroid
                    ? Share.share(
                        'check out our application from Google Play Store ${Api.androidLink}')
                    : Share.share(
                        'check out our application from App Store ${Api.iosLink}');
              },
              dense: true,
              leading: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Iconsax.share,
                  size: 20,
                  color: Color(0xffd12f26),
                ),
              ),
              title: const Text(
                'Share',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()));
              },
              dense: true,
              leading: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Iconsax.info_circle,
                  size: 20,
                  color: Color(0xffd12f26),
                ),
              ),
              title: const Text(
                'About Us',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
            ListTile(
              onTap: () {
                deleteMoadal('Delete Your Account',
                    'Are you sure you want to delete your account?');
              },
              dense: true,
              leading: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Iconsax.trash,
                  size: 20,
                  color: Color(0xffd12f26),
                ),
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}
