import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holy/models/services/register.dart';
import 'package:holy/models/services/reset.dart';
import 'package:holy/models/services/utls.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../nav_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();
// validating the username
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    // final regex =
    //     RegExp(r'^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]{3,30}(?<![_.])$');

    // if (!regex.hasMatch(value)) {
    //   return 'Use only letters, numbers, dots, or underscores';
    // }

    return null; // valid
  }

  Widget showname() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: name,
            validator: validateUsername,
            style: const TextStyle(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: const Icon(
                FontAwesomeIcons.user,
                color: Color(0xffd12f26),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: "Username",
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 16,
              ),
            )));
  }

  //validate the password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null; // valid
  }

  Widget showpassword() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: password,
            //autofocus: true,
            validator: validatePassword,
            obscureText: _obscureText,
            style: const TextStyle(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() => _obscureText = !_obscureText);
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: _obscureText ? const Color(0xffd12f26) : Colors.white,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: "Password",
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 16,
              ),
            )));
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 60,
                  height: 60,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
            );
          });
      postData();
    }
  }

  // Fetch otp api **************************
  void postData() async {
    var url = Uri.parse('${Api.baseUrl}/token/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "username": name.text,
      "password": password.text,
    };

    try {
      // POST request
      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
        //encoding: Encoding.getByName('utf-8'),
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var iyoo = json.decode(response.body);
        pref.setString('token', iyoo['access']);
        pref.setString('refresh', iyoo['refresh']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavPage()),
            (route) => false);
      } else {
        Navigator.pop(context);
        failMoadal('Oops! Looks like username or password is not correct');
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      failMoadal(
          'No internet connection, try again later'); // or return an error indicator
    } catch (e) {
      Navigator.pop(context);
      failMoadal(
          'Oops! It seems like Something not correct, check your No internet connection or try again later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/f.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.transparent, // Fade to transparent
                  Colors.black, // Top dark overlay
                ],
              ),
            ),
          ),

          // Foreground Content (Logo, Text, etc.)
          Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  showname(),
                  showpassword(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResetPage()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text('Forgot Password',
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontFamily: 'Inter',
                                fontSize: 12,
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          height: 45,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffd12f26),
                          ),
                          child: const Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //yangu mimi
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            //left: MediaQuery.of(context).size.width * 0.12,
            child: SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'HOLY ',
                            // _text.substring(0, _animation.value),
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                          Text(
                            'MOVIES',
                            // _text.substring(0, _animation.value),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xffd12f26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Color(0xffd12f26),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  failMoadal(String error) {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Something went Wrong',
                        style: TextStyle(
                          color: Color(0xff121212),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff121212),
                            fontSize: 14,
                          ),
                          error),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 120,
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: const Color(0xff121212),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                                child: Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
