import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:online_phone_book_app/screens/add_edit_screen.dart';
import 'package:online_phone_book_app/screens/home_screen.dart';
import 'package:online_phone_book_app/screens/license_screen.dart';
import 'package:online_phone_book_app/screens/splash_screen.dart';
import 'dart:developer' as developer;

import 'package:online_phone_book_app/services/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static late String connectionType;
  static bool isConnected = true;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize connection status on app start
  Future<void> initializeConnectionStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    updateConnectionType(connectivityResult);
    checkInternetAccess();
  }

  // Function to update connection type (Wi-Fi, mobile, none)
  void updateConnectionType(List<ConnectivityResult> result) {
    String connectionType;
    switch (result) {
      case [ConnectivityResult.wifi]:
        connectionType = 'Wi-Fi';
        break;
      case [ConnectivityResult.mobile]:
        connectionType = 'Mobile Data';
        break;
      case [ConnectivityResult.none]:
        connectionType = 'No Connection';
        break;
      default:
        connectionType = 'Unknown';
        break;
    }

    setState(() {
      MyApp.connectionType = connectionType;
    });
  }

  // Function to check if the device has actual internet access
  Future<void> checkInternetAccess() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    setState(() {
      MyApp.isConnected = hasInternet;
      if (MyApp.isConnected == false) {
        Network.CoolerAlert(context, () {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeConnectionStatus();
  }

  Future<bool> isActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isActive') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: "اپلیکیشن دفترچه تلفن آنلاین",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "aviny",
      ),
      home: FutureBuilder(
          future: isActive(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return SplashScreen();
            } else {
              return LicenseScreen();
            }
          }),
    );
  }
}
