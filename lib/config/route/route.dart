import 'package:Camera/features/camera/presentation/provider/camera_state.dart';
import 'package:Camera/config/route/routes_name.dart';
import 'package:Camera/features/camera/presentation/pages/camera_screen.dart';
import 'package:Camera/features/main/widgets/main_screen.dart';
import 'package:Camera/features/auth/presentation/widgets/authentication.dart';
import 'package:Camera/features/auth/presentation/pages/landing_page.dart';
import 'package:Camera/features/auth/presentation/pages/sign_in.dart';
import 'package:Camera/features/auth/presentation/pages/sign_up.dart';
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
