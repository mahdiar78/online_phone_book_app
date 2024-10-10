import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_phone_book_app/screens/home_screen.dart';
import 'package:online_phone_book_app/screens/splash_screen.dart';
import 'package:online_phone_book_app/widgets/my_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseScreen extends StatelessWidget {
  LicenseScreen({super.key});

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
  }

  void showSuccessDialog(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      width: 100,
      borderRadius: 20,
      title: "موفق",
      titleTextStyle: TextStyle(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
      text: "! کد با موفقیت کپی شد",
      textTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      confirmBtnText: "باشه",
      confirmBtnTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      confirmBtnColor: Colors.green,
      backgroundColor: Colors.green.shade100,
    );
  }

  final TextEditingController systemCodeController = TextEditingController();
  final TextEditingController activeCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getDeviceId().then((value) {
      systemCodeController.text = value ?? "";
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade400,
          elevation: 0,
          title: Text(
            "فعال سازی",
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  var bytes1 = utf8.encode(systemCodeController.text);
                  var digest1 = sha512256.convert(bytes1);
                  Clipboard.setData(
                    ClipboardData(text: digest1.toString()),
                  );
                  showSuccessDialog(context);
                },
                child: MyTextFormField(
                    isEnabled: false,
                    textType: TextInputType.text,
                    textController: systemCodeController,
                    hintText: "کد سیستم",
                    errorText: ""),
              ),
              MyTextFormField(
                  isEnabled: true,
                  textType: TextInputType.text,
                  textController: activeCodeController,
                  hintText: "کد فعال سازی",
                  errorText: "لطفا کد فعال سازی را وارد کنید"),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(
                  left: 100,
                  right: 100,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    var bytes1 = utf8.encode(systemCodeController.text);
                    var digest1 = sha512256.convert(bytes1);
                    print(digest1);
                    if (activeCodeController.text == digest1.toString()) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isActive', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "فعال سازی",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
