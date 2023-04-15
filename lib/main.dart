import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final LocalAuthentication authentication;
  bool _isSupportedState = false;
  @override
  void initState() {
    authentication = LocalAuthentication();
    authentication.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _isSupportedState = isSupported;
      });
    });
    super.initState();
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> available =
        await authentication.getAvailableBiometrics();
    log("list of biometrics -> $available");
    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await authentication.authenticate(
          localizedReason: "Subscribe to test",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));
      log("auth check -> $authenticated");
    } on PlatformException catch (e) {
      log("error -> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSupportedState)
                const Text("This device has biometric supported")
              else
                const Text("This device has biometric supported"),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: _getAvailableBiometrics,
                color: Colors.blueAccent,
                child: const Text(
                  "Auth Check",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: _authenticate,
                color: Colors.blueAccent,
                child: const Text(
                  "Authentication",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ));
  }
}
