import 'dart:developer';

import 'package:app/screens/account_statement.dart';
import 'package:app/screens/cases_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

import 'package:get/get.dart';
import '../widgets/custom_dialog.dart';
import 'constants.dart';

initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.setAutoInitEnabled(true);
  // iOS Notification Configuration

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     print("onMessage.listen");
    String buttonText = "";
    bool inBox = false;
    if (message.data['title'].toString().contains("box") ||
        message.data['body'].toString().contains("box")) inBox = true;

    if (message.data['click_action'] == "openCompletedCases")
      buttonText = "Completed Cases";
    else
      buttonText = "Account Statement";

    // refresh current balance, AE case and other data - 7aug24
    remoteServices.fetchData();
    if (navigatorKey.currentContext != null) {
       print("onMessage.listen played sounnd");
      if (message.notification!.title.toString().contains("Case") ||
          message.notification!.body.toString().contains("Case")) {
             
        playCaseSound();
      } else {
        playPaymentSound();
      }
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: message.notification!.title ?? "No Data Parameter",
              descriptions: message.notification!.body ?? "No Body Parameter",
              text: buttonText,
              inBox: inBox,
            );
          });
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(message.notification!.title.toString());
  //increaseNotificationCounter();
  if (message.notification!.title.toString().contains("Case") ||
      message.notification!.body.toString().contains("Case") ||
      message.notification!.title.toString().toLowerCase().contains("case") ||
      message.notification!.body.toString().toLowerCase().contains("case")) {

    playCaseSound();
  } else {
    playPaymentSound();
  }
}

void _handleMessage(RemoteMessage message) async {
   print("_handleMessage called");
  String iOSClickAction = "";
  // decreaseNotificationCounter();
  if (message.data['custom'] != null) {
    String clickAction = message.data['custom']['click_action'];
    iOSClickAction = clickAction;
    // Handle the click_action value (e.g., navigate to a specific screen)
  }

  if (message.data["click_action"] == "openCompletedCases" ||
      iOSClickAction == "openCompletedCases") {
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();
 if(isOnScreen(navigatorKey.currentContext!, CasesScreen()))
    {
      Navigator.of(navigatorKey.currentContext!).pop();
      pushIfNotCurrent(navigatorKey.currentContext!, CasesScreen(tabIndex: ValueNotifier<int>(1)));
    }
    else{
    pushIfNotCurrent(navigatorKey.currentContext!, CasesScreen(tabIndex: ValueNotifier<int>(1)));
    }
  //   Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CasesScreen(tabIndex: ValueNotifier<int>(1))));
 
  }
  ;
  if (message.data["click_action"] == "OpenAccountStatement" ||
      iOSClickAction == "OpenAccountStatement") {
    await remoteServices.getStatement();
    remoteServices.getCurrentBalance();
    
    log("current route is ${Get.currentRoute}");

    //  REFRESH STATMENT SCREEN AND UPDATE BALANCE
    // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(MaterialPageRoute(
    //   builder: (BuildContext context) => const HomeScreen(),
    // ), (Route<dynamic> route) => false,
    // );
    //    Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
    //   builder: (BuildContext context) => const HomeScreen(),
    // ),
    // );
    pushIfNotCurrent(navigatorKey.currentContext!, AccountStatementScreen());
  }
}

  void pushIfNotCurrent(BuildContext context, Widget page) {
    log("FCM PUSH CALLED");

  bool isOnHomeScreen = false;
 
 Navigator.of(context).popUntil((route) {
  // Check if the route has a name
  print("route name : ${route.settings.name}");
  if (route.settings.name == null) {
    if (route is MaterialPageRoute) {
      // Print the runtime type of the builder associated with the route
      print("Is a MaterialPageRoute: ${route.builder(context).runtimeType}");
    } else {
      isOnHomeScreen = true;
      print("Not a MaterialPageRoute");
    }
  }
  return true; // Continue popping until the condition is met
});
  log("isOnHomeScreen $isOnHomeScreen");
  
   if(!isOnHomeScreen){
      Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => page));
      }
  else
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
bool isOnScreen(BuildContext context, Widget page) {
  bool isCurrentBool = false;

  Navigator.of(context).popUntil((route) {
    if (route.settings.name == null) {
      // Check if the route is of the same type as the page you intend to push
      if (route is MaterialPageRoute &&
          route.builder(context).runtimeType == page.runtimeType) {
        isCurrentBool = true;
      }
    }
    return true;
  });

  return isCurrentBool;
}

void playPaymentSound() async {
  final AudioPlayer player = AudioPlayer();
  await player.play(AssetSource("sounds/payment.wav"));
}

playCaseSound() async {
  final AudioPlayer player = AudioPlayer();
  await player.play(AssetSource("sounds/case.wav"));
}

increaseNotificationCounter() async {
  try {
    int badgeNumber = await FlutterDynamicIcon.getApplicationIconBadgeNumber();
    await FlutterDynamicIcon.setApplicationIconBadgeNumber(badgeNumber + 1);
  } on PlatformException {
    print('Exception: Platform not supported');
  } catch (e) {
    print(e);
  }
}

decreaseNotificationCounter() async {
  try {
    int badgeNumber = await FlutterDynamicIcon.getApplicationIconBadgeNumber();
    if (badgeNumber == 0) return;
    await FlutterDynamicIcon.setApplicationIconBadgeNumber(badgeNumber - 1);
  } on PlatformException {
    print('Exception: Platform not supported');
  } catch (e) {
    print(e);
  }
}
