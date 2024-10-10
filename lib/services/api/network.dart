import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Network {
  static Uri url = Uri.parse("https://retoolapi.dev/hpJjBn/contacts");

  static Uri urlWithId(String id) {
    return Uri.parse("https://retoolapi.dev/hpJjBn/contacts/$id");
  }

  static List<Contact> contacts = [];

  static void CoolerAlert(BuildContext context,Function() onPressed) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      width: 100,
      borderRadius: 20,
      title: "خطا",
      titleTextStyle: TextStyle(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
      text: "! شما به اینترنت متصل نیستید",
      textTextStyle: TextStyle(fontSize: 20 , color: Colors.black),
      confirmBtnText: "باشه",
      confirmBtnTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      confirmBtnColor: Colors.red,
      backgroundColor: Colors.red.shade200,
      onConfirmBtnTap: onPressed,
    );
  }

  // Get Data
  static Future<void> getData() async {
    Network.contacts.clear();
    http.get(Network.url).then((response) {
      if (response.statusCode == 200) {
        List jsonDecode = convert.jsonDecode(response.body);
        for (var json in jsonDecode) {
          Network.contacts.add(Contact.fromJson(json));
        }
      }
    });
  }

  // Post Data
  static Future<void> postData(
      {required String fullName, required String phone}) async {
    Contact contact = Contact(phone: phone, fullName: fullName);
    http.post(Network.url, body: contact.toJson());
  }

  // Put Data
  static Future<void> putData(
      {required int id,
      required String fullName,
      required String phone}) async {
    Contact contact = Contact(phone: phone, fullName: fullName);
    http
        .put(Network.urlWithId(id.toString()), body: contact.toJson())
        .then((response) {
      print(response.body);
    });
  }

  // Delete Data
  static Future<void> deleteData({required int id}) async {
    http.delete(urlWithId(id.toString()));
  }
}
