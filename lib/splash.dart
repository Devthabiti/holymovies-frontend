import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:holy/models/services/login.dart';
import 'package:holy/nav_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'errors/error_screen.dart';
import 'models/providers/token_provider.dart';
import 'package:http/http.dart' as http;

import 'models/services/utls.dart';

class SplashPage extends StatefulWidget {
  final String? token;
  const SplashPage({super.key, required this.token});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool valid = false;
  void isTokenValid(String token) async {
    try {
      final response =
          await http.post(Uri.parse('${Api.baseUrl}/check-validit/'), body: {
        "refresh": token,
      });

      if (response.statusCode == 200) {
        setState(() {
          valid = true;
        });
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ErrorScreenPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    //checking is valid or not
    if (widget.token != null) {
      isTokenValid(widget.token!);
    }
    //fetch all api before run anything
    final data = context.read<ApiCalls>();

    data.fetchReview();
    data.fetchMovie();
    data.fetchWatchlist();
    data.fetchPayment();
    data.fetchCarsole();
    context.read<ApiCalls>().userID();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
          decoration: const BoxDecoration(color: Color(0xff121212)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'HOLY ',
                      // _text.substring(0, _animation.value),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Text(
                      'MOVIES',
                      // _text.substring(0, _animation.value),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffE50914)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 500,
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          )),
      nextScreen: valid ? const NavPage() : const LoginPage(),
      splashIconSize: MediaQuery.of(context).size.height,
      duration: 5000,
    );
  }
}




  // Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage('assets/ac.jpg'), fit: BoxFit.cover)),
      //     child: Container(
      //       decoration:
      //           BoxDecoration(color: Color(0xff121212).withOpacity(0.5)),
      //       child: Stack(
      //         children: [
      //           Positioned(
      //             top: MediaQuery.of(context).size.height * 0.1,
      //             left: MediaQuery.of(context).size.width * 0.3,
      //             child: Text(
      //               'HOLY MOVIES',
      //               style: const TextStyle(
      //                   fontSize: 26.0,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white),
      //             ),
      //           ),
      //           Positioned(
      //             bottom: MediaQuery.of(context).size.height * 0.1,
      //             // left: MediaQuery.of(context).size.width * 0.3,

      //             child: Container(
      //               height: 300,
      //               width: MediaQuery.of(context).size.width * 0.9,
      //               margin: const EdgeInsets.all(20),
      //               decoration: BoxDecoration(
      //                   color: Color(0xff1E1E1E),
      //                   borderRadius: BorderRadius.circular(10)),
      //               child: Column(
      //                 children: [
      //                   SizedBox(
      //                     height: 25,
      //                   ),
      //                   Text(
      //                     textAlign: TextAlign.center,
      //                     'Streaming Stories of Faith and Hope'.toUpperCase(),
      //                     style: const TextStyle(
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold,
      //                         color: Colors.white),
      //                   ),
      //                   SizedBox(
      //                     height: 25,
      //                   ),
      //                   Text(
      //                     textAlign: TextAlign.center,
      //                     'Discover a carefully curated collection of inspiring movies, spiritual dramas, biblical epics, and uplifting stories that reflect the love, grace, and power of God',
      //                     style: const TextStyle(
      //                         fontSize: 12.0, color: Colors.white),
      //                   ),
      //                   SizedBox(
      //                     height: 45,
      //                   ),
      //                   CircularProgressIndicator()
      //                 ],
      //               ),
      //             ),
      //           ),
      //           // Positioned(child: CircularProgressIndicator())
      //         ],
      //       ),
      //     )),