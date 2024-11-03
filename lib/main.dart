import 'dart:ui';

import 'package:app/controllers/notification_contoller.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/FCM_Service.dart';
import 'package:app/utils/ScreenOrientationManager.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/main_bindings.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); /*.then((value) => Get.put(AuthController()));*/
    final NotificationController notificationController = Get.put(NotificationController());



//  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
// FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//notificationController.remoteMessage = initialMessage;
  FlutterError.onError = (errorDetails) {
    print(" flutter error ");
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    print(" platform ");
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
   await GetStorage.init();
  initializeFCM();
   // Set allowed orientations for the whole app
  OrientationManager.setPortraitMode();
  runApp(const SigmaApplication());
}

class SigmaApplication extends StatefulWidget {
  const SigmaApplication({Key? key}) : super(key: key);

  @override
  State<SigmaApplication> createState() => _SigmaApplicationState();
}

class _SigmaApplicationState extends State<SigmaApplication> {

@override
  void initState() {
    
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Received a message: ${message.messageId}');
    // });
   
  }

  @override
  Widget build(BuildContext context) {
      precacheImage(AssetImage(backgroundPath), context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
    // Retrieve the MediaQueryData from the current context.
    final mediaQueryData = MediaQuery.of(context);

    // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
    final scale = mediaQueryData.textScaler.clamp(
      minScaleFactor: 1.0, // Minimum scale factor allowed.
      maxScaleFactor: 1.3, // Maximum scale factor allowed.
    );


        return MediaQuery(
           data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: GetMaterialApp(
              theme: ThemeData(
              ),
              initialBinding: MainBindings(),
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              home:  LoginScreen()),
        );
      },
    );
  }
}
