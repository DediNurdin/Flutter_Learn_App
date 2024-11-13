import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FaceFingerPrintAuth extends StatefulWidget {
  const FaceFingerPrintAuth({super.key});

  @override
  State<FaceFingerPrintAuth> createState() => _FaceFingerPrintAuthState();
}

class _FaceFingerPrintAuthState extends State<FaceFingerPrintAuth> {
  late final LocalAuthentication myauthentication;
  bool authState = false;
  bool authSuccess = false;

  @override
  void initState() {
    super.initState();
    myauthentication = LocalAuthentication();
    myauthentication.isDeviceSupported().then(
          (bool myAuth) => setState(
            () {
              authState = myAuth;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Flutter Biometrics Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: authentication,
                child: const Text(
                  "Authenticate",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            Visibility(
              visible: authSuccess,
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> authentication() async {
    try {
      setState(() {
        authSuccess = false;
      });
      bool isAuthenticate = await myauthentication.authenticate(
        localizedReason: " local authentication",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (kDebugMode) {
        print("Authentication Status is: $isAuthenticate");
      }
      setState(() {
        if (isAuthenticate) {
          authSuccess = true;
        } else {
          authState = false;
        }
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) {
      return;
    }
  }
}
