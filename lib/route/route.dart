import 'package:Camera/provider/camera_state.dart';
import 'package:Camera/route/routes_name.dart';
import 'package:Camera/screen/camera/camera_screen.dart';
import 'package:Camera/screen/main_screen/main_screen.dart';
import 'package:Camera/screen/pre_login/authentication.dart';
import 'package:Camera/screen/pre_login/landing_page.dart';
import 'package:Camera/screen/pre_login/sign_in.dart';
import 'package:Camera/screen/pre_login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.start:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case AppRouteName.signin:
        return MaterialPageRoute(builder: (_) => const SignInWidget());
      case AppRouteName.signup:
        return MaterialPageRoute(builder: (_) => const SignUpWidget());
      case AppRouteName.mainscreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRouteName.camera:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (BuildContext context) => CameraState(),
                child: const CameraApp()));
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
