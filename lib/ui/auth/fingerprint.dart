import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hidden_box/ui/splash.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintUI extends StatefulWidget {
  @override
  _FingerPrintUIState createState() => _FingerPrintUIState();
}

class _FingerPrintUIState extends State<FingerPrintUI> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String authorized = "Not authorized";

  //checking bimetrics
  //this function will check the sensors and will tell us
  // if we can use them or not
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  //this function will get all the available biometrics inside our device
  //it will return a list of objects, but for our example it will only
  //return the fingerprint biometric
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  //this function will open an authentication dialog
  // and it will check if we are authenticated or not
  // so we will add the major action here like moving to another activity
  // or just display a text that will tell us that we are authenticated
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan your finger print to authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      authorized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      if (authenticated) {
        Get.to(SplashUI());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkBiometric();
    _getAvailableBiometrics();
  }

//********************************* */
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  // bool _canCheckBiometric = false;
  // String _authorizedOrNot = "Not Authorized";
  // List<BiometricType> _availableBiometricTypes = List<BiometricType>();
  // Future<void> _checkBiometric() async {
  //   bool canCheckBiometric = false;
  //   try {
  //     canCheckBiometric = await _localAuthentication.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _canCheckBiometric = canCheckBiometric;
  //   });
  // }

  // Future<void> _getListOfBiometricTypes() async {
  //   List<BiometricType> listofBiometrics;
  //   try {
  //     listofBiometrics = await _localAuthentication.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _availableBiometricTypes = listofBiometrics;
  //   });
  // }

  // Future<void> _authorizeNow() async {
  //   bool isAuthorized = false;
  //   try {
  //     isAuthorized = await _localAuthentication.authenticateWithBiometrics(
  //       localizedReason: "Please authenticate to complete your transaction",
  //       useErrorDialogs: true,
  //       stickyAuth: true,
  //     );
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     if (isAuthorized) {
  //       _authorizedOrNot = "Authorized";
  //     } else {
  //       _authorizedOrNot = "Not Authorized";
  //     }
  //   });
  // }

//********************************* */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff3c3e52),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Get Access",
                  style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/fingerprint.png",
                      width: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "FingerPrint Auth",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Authinticate Using your fingerprint",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: _authenticate,
                        color: Color(0xff04a5ed),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0.0,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            child: Text(
                              "Authinticate",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: _authenticate,
                  child: Text("Get Biometric"),
                ),
              ),
              Text("Can check biometric: $_canCheckBiometric"),
              Text("Available biometric: $_availableBiometric"),
              Text("Current State: $authorized"),
            ],
          ),
        ),
      ),
    );
  }
}
