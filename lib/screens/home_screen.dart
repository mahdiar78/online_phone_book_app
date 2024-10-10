import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:online_phone_book_app/main.dart';
import 'package:online_phone_book_app/screens/add_edit_screen.dart';
import 'package:online_phone_book_app/services/api/network.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static int index = 0;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

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
        Network.CoolerAlert(context, (){});
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
          updateConnectionType(result);
          checkInternetAccess();
        });
    if (MyApp.isConnected == true) {
      Network.getData().then((value) async {
        await Future.delayed(Duration(seconds: 3));
        setState(() {});
      });
    }
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      connectivitySubscription.cancel();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade400,
          elevation: 0,
          title: Text(
            "دفترچه تلفن آنلاین",
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          centerTitle: true,
          leading: Icon(
            Icons.import_contacts_sharp,
            color: Colors.white,
            size: 28,
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (MyApp.isConnected == true) {
                  Network.getData().then((value) async {
                    await Future.delayed(Duration(seconds: 3));
                    setState(() {});
                    print("refresh done!!!");
                  });
                } else {
                  Network.CoolerAlert(context, () {});
                }
              },
              icon: Icon(
                Icons.refresh_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AddEditScreen.nameController.text = "";
            AddEditScreen.phoneController.text = "";
            AddEditScreen.isEditing = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddEditScreen();
                },
              ),
            ).then((value) async {
              await Future.delayed(Duration(seconds: 2));
              Network.getData();
              await Future.delayed(Duration(seconds: 2));
              //print(Network.contacts);
              setState(() {});
            });
          },
          elevation: 0,
          backgroundColor: Colors.red.shade400,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        body: ListView.builder(
          itemCount: Network.contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 27),
                ),
                backgroundColor: Colors.red.shade400,
                radius: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  Network.contacts[index].fullName,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  Network.contacts[index].phone,
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  AddEditScreen.isEditing = true;
                  HomeScreen.index = index;
                  AddEditScreen.nameController.text =
                      Network.contacts[index].fullName;
                  AddEditScreen.phoneController.text =
                      Network.contacts[index].phone;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddEditScreen();
                      },
                    ),
                  ).then((value) async {
                    await Future.delayed(Duration(seconds: 2));
                    Network.getData();
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {});
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),
              onLongPress: () async {
                if (MyApp.isConnected == true) {
                  Network.deleteData(id: Network.contacts[index].id!)
                      .then((value) async {
                    await Future.delayed(Duration(seconds: 2));
                    Network.getData();
                    await Future.delayed(Duration(seconds: 2));
                    print(Network.contacts);
                    setState(() {});
                  });
                } else {
                  Network.CoolerAlert(context, () {});
                }
              },
            );
          },
        ),
      ),
    );
  }
}
