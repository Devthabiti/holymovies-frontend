import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ErrorScreenPage extends StatefulWidget {
  const ErrorScreenPage({super.key});

  @override
  State<ErrorScreenPage> createState() => _ErrorScreenPageState();
}

class _ErrorScreenPageState extends State<ErrorScreenPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
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
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.6),
          enabled: true,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ListTile(
                    leading: Container(
                      width: 70.0,
                      height: 56.0,
                      color: Colors.white,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 200.0,
                          height: 15.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                    subtitle: Container(
                      width: 170.0,
                      height: 86.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
