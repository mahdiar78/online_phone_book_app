import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:online_phone_book_app/screens/home_screen.dart';

import '../main.dart';
import '../services/api/network.dart';
import '../widgets/my_text_form_field.dart';

class AddEditScreen extends StatefulWidget {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static bool isEditing = false;

  AddEditScreen({super.key});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red.shade400,
              elevation: 0,
              title: Text(
                AddEditScreen.isEditing == true ? "ویرایش مخاطب" : "مخاطب جدید",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    isEnabled: true,
                    hintText: "نام",
                    textType: TextInputType.text,
                    errorText: "لطفا نام را وارد کنید",
                    textController: AddEditScreen.nameController,
                  ),
                  MyTextFormField(
                    isEnabled: true,
                    hintText: "شماره",
                    textType: TextInputType.number,
                    errorText: "لطفا شماره را وارد کنید",
                    textController: AddEditScreen.phoneController,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 100, right: 100, top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (MyApp.isConnected == true) {
                            AddEditScreen.isEditing == false
                                ? Network.postData(
                                    fullName: AddEditScreen.nameController.text,
                                    phone: AddEditScreen.phoneController.text)
                                : Network.putData(
                                    id: Network.contacts[HomeScreen.index].id!,
                                    fullName: AddEditScreen.nameController.text,
                                    phone: AddEditScreen.phoneController.text);
                            AddEditScreen.nameController.text = "";
                            AddEditScreen.phoneController.text = "";
                            Navigator.pop(context);
                          } else {
                            Network.CoolerAlert(context, () {});
                          }
                        }
                      },
                      child: Text(
                        AddEditScreen.isEditing == true
                            ? "ویرایش کردن"
                            : "اضافه کردن",
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
        ),
      ),
    );
  }
}
