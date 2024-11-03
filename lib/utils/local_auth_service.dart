import 'dart:developer' as dev;
import 'dart:math';

import 'package:app/controllers/auth_controller.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'encrypt.dart';
import "package:intl/intl.dart";
final authController = Get.find<AuthController>();

Future<String> saveDeviceId() async {
  if(getData('device_id') != null) return getData('device_id');
  final deviceInfo = DeviceInfoPlugin();
  String deviceId="";

try{
  // Get device identifier based on platform
  if (Theme.of(Get.context!).platform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id; // Unique Android ID
  } else if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? "123"; // Unique iOS ID
  }
}
catch(e){
  var rng = Random();
 deviceId = (rng.nextInt(100000 - 10000) + 10000).toString();
  //setData('device_id', randomNum.toString());
}

    setData('device_id', deviceId);
    print('Device ID saved: $deviceId');

  return deviceId;
}
  
void checkAuthorization() async{
  print("checkAuthorization called");
  bool authorized = true;
  String reasonUnAuthorized ="";
  var response =await http.post(Uri.parse(clientInfoAddress),body: {
    'phoneNum' : encrypt(authController.client.value.phone!),
    'password': getData("password")
  });

  if (response.statusCode != 200)  {
    authorized = false;
    reasonUnAuthorized = "Number not found";
  }
 
  if(!authorized) {
    print("Authorization failed,$reasonUnAuthorized, Logging out..");
    bool? accountType =getBool("accountType");
    if (accountType != null) {
      if (accountType == true)
        authController.removeNotificationToken(1,authController.client.value.id!);
      else
        authController.removeNotificationToken(0,authController.client.value.id!);
    }
    authorized = false;
    authController.logout();
    authController.errorMsg.value = "Number used is no longer associated with an account, contact SIGMA.";
    authController.errorMsgColor = Colors.red;
    Get.clearRouteTree();
    Get.offAll(()=>LoginScreen());
  }

}
bool sessionTimedOut(){
  String? firstLoginTime = getString("loginTime");
  dev.log("firstLoginTime $firstLoginTime");
  if (firstLoginTime == null) return true;

  DateTime loginDate =  DateFormat("yyyy-MM-dd hh:mm a").parse(firstLoginTime);
  DateTime now = DateFormat("yyyy-MM-dd hh:mm").parse(DateTime.now().toString());
  Duration minutesPassed = now.difference(loginDate);
  dev.log("minutesPassed.inHours ${minutesPassed.inHours}");
  if (minutesPassed.inSeconds > 15)
    return false;
  else
    return true;
}