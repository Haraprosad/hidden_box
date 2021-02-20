import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_box/ui/auth/fingerprint.dart';
import 'package:hidden_box/ui/splash.dart';
import 'package:hidden_box/utils/theme/theme_data.dart';
import 'package:hidden_box/utils/theme/themes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hidden Box',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      themeMode: ThemeService.theme,
      darkTheme: Themes.dark,
      theme: Themes.light,
      //todo: splashUI
      home: FingerPrintUI(),
    );
  }
}
