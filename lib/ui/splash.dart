import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_box/envs.dart';
import 'package:hidden_box/ui/auth/check_master_password.dart';
import 'package:hidden_box/ui/auth/login_ui_page.dart';
import 'package:hidden_box/ui/auth/verify_otp.dart';
import 'package:hidden_box/utils/encrtypt.dart';
import 'package:hidden_box/utils/image_const.dart';

class SplashUI extends StatefulWidget {
  @override
  _SplashUIState createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  @override
  void initState() {
    Timer(Duration(seconds: 10), () => handleSplashScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                ImageConst.SPLASH_ICON,
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Hidden Box",
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //handle splash screen
  void handleSplashScreen() async {
    //before going to next PAGE INIT Encryptor
    Encrypter encrypter =
        initEncryptor(MyEnvironment.passKey);
    //put into GetX, so that it can be accessed from across the APP
    Get.put<Encrypter>(encrypter, tag: "ENCRYPT", permanent: true);

    var user = FirebaseAuth.instance.currentUser;

    //check user is null or not
    //if null goto login page
    if (user == null) {
      Get.offAll(LoginPageUI());
      return;
    }

    //check user email is verified or not
    //if not send to verify page
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      Get.offAll(VerifyOTP());
      return;
    }

    //otherwise go to master pass ui page
    Get.offAll(CheckMasterPassUI());
  }
}
