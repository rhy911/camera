import 'dart:async';
import 'package:Camera/config/route/route.dart';
import 'package:Camera/config/themes/provider/theme_provider.dart';
import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:Camera/features/main/discover/provider/discovery_provider.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Camera/config/themes/app_theme.dart';
import 'package:Camera/core/data/firebase/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Camedit',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeData,
          onGenerateRoute: AppRoute.generate,
        );
      },
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
        ChangeNotifierProvider<CameraProvider>(
            create: (context) => CameraProvider()),
        ChangeNotifierProvider<provider.ImageProvider>(
            create: (context) => provider.ImageProvider()),
        ChangeNotifierProvider<DiscoveryProvider>(
            create: (context) => DiscoveryProvider()),
      ],
    );
  }
}
