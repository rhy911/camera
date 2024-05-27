import 'package:Camera/features/camera/presentation/pages/image_preview.dart';
import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:Camera/config/route/routes_name.dart';
import 'package:Camera/features/camera/presentation/pages/camera_screen.dart';
import 'package:Camera/features/editor/presentation/editing_screen.dart';
import 'package:Camera/features/editor/presentation/pages/crop_page.dart';
import 'package:Camera/features/editor/presentation/pages/filters_page.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:Camera/features/main/discover/presentation/widgets/image_view.dart';
import 'package:Camera/features/main/gallery/presentation/widgets/image_view_gallery.dart';
import 'package:Camera/features/main/main_screen.dart';
import 'package:Camera/features/auth/presentation/widgets/authentication.dart';
import 'package:Camera/features/auth/presentation/pages/starting_page.dart';
import 'package:Camera/features/auth/presentation/pages/sign_in.dart';
import 'package:Camera/features/auth/presentation/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRouteName.start:
        return MaterialPageRoute(builder: (_) => const StartingScreen());
      case AppRouteName.signin:
        return MaterialPageRoute(builder: (_) => const SignInWidget());
      case AppRouteName.signup:
        return MaterialPageRoute(builder: (_) => const SignUpWidget());
      case AppRouteName.mainscreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRouteName.camera:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (BuildContext context) => CameraProvider(),
                child: const CameraApp()));
      case AppRouteName.imagepreview:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as CameraProvider, child: const ImagePreview()));
      case AppRouteName.imageGalleryView:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as provider.ImageProvider,
                child: const ImageGaleryView()));
      case AppRouteName.imageDiscoveryView:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as provider.ImageProvider,
                child: const ImageDiscoveryView()));
      case AppRouteName.edit:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as provider.ImageProvider,
                child: const EditingScreen()));
      case AppRouteName.cropper:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as provider.ImageProvider, child: CropPage()));
      case AppRouteName.filter:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: args as provider.ImageProvider,
                child: const FiltersPage()));
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
