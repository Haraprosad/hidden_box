import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_box/controller/app_controller.dart';
import 'package:hidden_box/ui/shared/auth_helper_ui.dart';

class ChnageMasterPasswordUI extends StatelessWidget {
  String currentpass = "";
  String newpass = "";
  String confirmPass = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        margin: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AuthHelper.getAppBar(height: Get.height * 0.15),
              AuthHelper.clipShape(
                roundIconTop: Get.height * 0.07,
                firstCliperHight: Get.height * 0.2,
                secondCliperHeight: Get.height * 0.2,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Update Masterpassword",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              passwordForm(),
              SizedBox(
                height: 50,
              ),
              AuthHelper.getAuthButton("UPDATE", () {
                if (_formKey.currentState.validate()) {
                  AppController.to
                      .updateMasterPassword(currentpass, newpass, confirmPass);
                }
              }),
              //signInTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      margin: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 30,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            passwordTextFiled(
              "Current Password",
              (value) {
                currentpass = value;
              },
            ),
            SizedBox(height: 10),
            passwordTextFiled(
              "New password",
              (value) {
                currentpass = value;
              },
            ),
            SizedBox(height: 10),
            passwordTextFiled(
              "Confirm password",
              (value) {
                confirmPass = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordTextFiled(String hint, void onChange(String value)) {
    return ObxValue(
      (data) => Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5,
        color: Get.isDarkMode ? Colors.white30 : Colors.white,
        child: TextFormField(
          onChanged: (value) {
            onChange(value);
          },
          cursorColor: Colors.blue[200],
          validator: (value) => value.isNotEmpty && value.length >= 6
              ? null
              : "Enter valid password (min length: 6)",
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.blue[500],
              size: 20,
            ),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                data.value = !data.value;
              },
              child: Icon(
                data.value ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          obscureText: data.value,
        ),
      ),
      true.obs,
    );
  }
}
