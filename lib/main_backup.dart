import 'dart:async';
import 'package:camera_app/config/route/route.dart';
import 'package:camera_app/config/themes/provider/theme_provider.dart';
import 'package:camera_app/features/camera/provider/camera_state.dart';
import 'package:camera_app/features/main/discover/provider/discovery_provider.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera_app/config/themes/app_theme.dart';
import 'package:camera_app/core/data/firebase/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:camera_app/features/editor/provider/image_provider.dart'
    as provider;

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  try {
    cameras = await availableCameras();
    print('Cameras initialized successfully: ${cameras.length} cameras found');
  } catch (e) {
    print('Camera initialization error: $e');
    cameras = [];
  }
  
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
    try {
      runApp(const MyApp());
    } catch (e) {
      print('Error running app: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Camedit',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeData,
            initialRoute: '/',
            onGenerateRoute: AppRoute.generate,
          );
        },
      ),
    );
  }
}
