import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/biometric_auth/biometric_auth_page.dart';
import 'package:flutter_learn/weather_app/view/weather_page.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool loadWeather = false;

class _HomePageState extends State<HomePage> {
  Position? currentPosition;
  @override
  void initState() {
    LocationHandler.handleLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      loadWeather = false;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          btnMenu(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FaceFingerPrintAuth()),
            );
          }, const Text('Biometric Auth')),
          btnMenu(() async {
            setState(() {
              loadWeather = true;
            });
            currentPosition = await LocationHandler.getCurrentPosition(context);
            setState(() {
              loadWeather = false;
            });
          },
              loadWeather
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : const Text('Weather App'))
        ],
      ),
    );
  }

  Widget btnMenu(
    void Function() onTap,
    Widget wgt,
  ) {
    return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
            onPressed: onTap,
            child: wgt));
  }
}

abstract class LocationHandler {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition(BuildContext context) async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
      );

      return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WeatherHome(lat: position.latitude, lon: position.longitude)),
      );
    } catch (e) {
      return null;
    }
  }
}
