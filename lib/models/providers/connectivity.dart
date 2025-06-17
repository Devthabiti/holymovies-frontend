import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription _subscription;

  ConnectivityProvider() {
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((status) async {
      bool previous = _isOnline;
      if (status == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        _isOnline = true;
      }
      if (_isOnline != previous) notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
