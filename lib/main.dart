import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holy/models/providers/connectivity.dart';
import 'package:holy/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/providers/token_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('refresh');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ApiCalls()),
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE50914)),
        // primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      home: SplashPage(token: token),
    ),
  ));
}


///colors
/// Background (main) #121212
/// Accent Red  #d12f26
/// Text - Primary (white)	#FFFFFF
/// Text - Secondary (gray)	#B3B3B3
/// Card/Dark Surface	#1E1E1E 
/// Muted Icon Color	#A0A0A0 
/// Tag Highlight (Trending)	#FF3B30