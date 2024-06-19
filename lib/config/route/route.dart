import 'package:Camera/features/auth/presentation/pages/verification.dart';
import 'package:Camera/features/camera/presentation/pages/image_preview.dart';
import 'package:Camera/config/route/routes_name.dart';
import 'package:Camera/features/camera/presentation/pages/camera_screen.dart';
import 'package:Camera/features/editor/presentation/editing_screen.dart';
import 'package:Camera/features/editor/presentation/pages/adjust_page.dart';
import 'package:Camera/features/editor/presentation/pages/crop_page.dart';
import 'package:Camera/features/editor/presentation/pages/draw_page.dart';
import 'package:Camera/features/editor/presentation/pages/filters_page.dart';
import 'package:Camera/features/editor/presentation/pages/stickers_page.dart';
import 'package:Camera/features/editor/presentation/pages/text_page.dart';
import 'package:Camera/features/main/discover/presentation/widgets/image_view.dart';
import 'package:Camera/features/main/gallery/presentation/widgets/image_view_gallery.dart';
import 'package:Camera/features/main/main_screen.dart';
import 'package:Camera/features/auth/presentation/widgets/authentication.dart';
import 'package:Camera/features/auth/presentation/pages/starting_page.dart';
import 'package:Camera/features/auth/presentation/pages/sign_in.dart';
import 'package:Camera/features/auth/presentation/pages/sign_up.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.start:
        return MaterialPageRoute(builder: (_) => const StartingScreen());
      case AppRouteName.signin:
        return MaterialPageRoute(builder: (_) => const SignInWidget());
      case AppRouteName.signup:
        return MaterialPageRoute(builder: (_) => const SignUpWidget());
      case AppRouteName.verification:
        return MaterialPageRoute(builder: (_) => const EmailVerification());
      case AppRouteName.mainscreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRouteName.camera:
        return MaterialPageRoute(builder: (_) => const CameraApp());
      case AppRouteName.imagepreview:
        return MaterialPageRoute(builder: (_) => const ImagePreview());
      case AppRouteName.imageGalleryView:
        return MaterialPageRoute(builder: (_) => const ImageGalleryView());
      case AppRouteName.imageDiscoveryView:
        return MaterialPageRoute(builder: (_) => const ImageDiscoveryView());
      case AppRouteName.edit:
        return MaterialPageRoute(builder: (_) => const EditingScreen());
      case AppRouteName.cropper:
        return MaterialPageRoute(builder: (_) => CropPage());
      case AppRouteName.filter:
        return MaterialPageRoute(builder: (_) => const FiltersPage());
      case AppRouteName.adjust:
        return MaterialPageRoute(builder: (_) => const AdjustPage());
      case AppRouteName.text:
        return MaterialPageRoute(builder: (_) => const TextPage());
      case AppRouteName.sticker:
        return MaterialPageRoute(builder: (_) => const StickersPage());
      case AppRouteName.draw:
        return MaterialPageRoute(builder: (_) => const DrawPage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
