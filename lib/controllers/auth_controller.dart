import 'dart:convert';
import 'dart:developer';
import 'package:app/controllers/remote_services_controller.dart';
import 'package:app/utils/local_auth_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app/models/client.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/screens/welcome_screen.dart';
import 'package:app/utils/encrypt.dart';
import 'package:app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  //final LocalAuthentication localAuth = LocalAuthentication();

  // late BiometricType _biometricType
  late final AppLifecycleListener _listener;
  Rx<bool> isDoctorAccount = false.obs;
  Rx<String> errorMsg = "Unknown Error".obs;
  Color errorMsgColor = Colors.red;
  Rx<bool> isLoggedIn = false.obs;
  Rx<Client> client = Client().obs;
bool _isListenerAttached = false;
  @override
  void onReady() async {
 if (!_isListenerAttached) {
  log("Attaching AppLifecycleListener");
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
     _isListenerAttached = true; // Mark the listener as attached
  }
    print("Is Logged In: $isLoggedIn");
    print("Is Logged In: ${await getData("isLoggedIn")}");
    isLoggedIn.value = await getData("isLoggedIn") ?? false;
    saveDeviceId();
    isLoggedIn.listen((value) {
      print("Is Logged In: $value");
      if (!value) {
        print("lestenner here");
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  /// Logs the user in and sets the client data.
  ///
  /// Sets the phone number, password, login time, and background time in storage.
  /// If the login is successful, navigates to the welcome screen.
  /// If the login fails, sets the error message and logs the user out.
  ///
  /// Returns true if the login is successful, false otherwise.
  Future<bool> login(String phoneNum, String password) async {
    if (getData("device_id") == null) {await saveDeviceId();}
    var response = await http.post(Uri.parse(loginAddress),
        body: {"phoneNum": encrypt(phoneNum), "password": password, 'deviceId': getData('device_id') ?? "0"});
    // Get.context!..show();
    if (response.statusCode == 200) {
      client.value = Client.fromJson(jsonDecode(response.body));
      setAccessLevel(phoneNum);
      isLoggedIn.value = true;
      setData("isLoggedIn", true);
      setData("phoneNum", phoneNum);
      setData("password", password);
      setData("loginTime", DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()));
          setData("backgroundTime", DateTime.now().millisecondsSinceEpoch);
      remoteServices.registerLogin();
      Navigator.of(Get.context!).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
      return true;
    } else {
     // errorMsg.value = jsonDecode(response.body)["msg"];
      logout();
      setData("isLoggedIn", false);
      return false;
    }
  }

  Future<void> logout() async {
    log("Logout called");
    bool? accountType = getBool("accountType") ?? isDoctorAccount.value;
    if (accountType == true)
    removeNotificationToken(1, client.value.id!);
    else
    removeNotificationToken(0, client.value.id!);
   // client = Client().obs;
    final remoteServicesController = Get.find<RemoteServicesController>();
    remoteServicesController.clearPersonlizedData();
   // isLoggedIn.value == false;
    print("account type : $accountType");
    Get.offAll(() => const LoginScreen(autoFillWithBioAuth: false,));
  }

  void setAccessLevel(String phoneNumberEntered) {
    if (client.value.phone!
        .contains(phoneNumberEntered.substring(phoneNumberEntered.length - 7)))
      isDoctorAccount.value = true;
    else
      isDoctorAccount.value = false;
    setData("accountType", isDoctorAccount.value);
  }

  Future<void> removeNotificationToken(int accountType, int docId) async {
    print("doc id : $docId, account type : $accountType");
    var response = await http.post(Uri.parse(removeTokenAddress), body: {
      'docId': docId.toString(),
      "accountType": accountType.toString(),
      "deviceId":  getData('device_id') ?? "0"
    });
    print(
        "removed notification token, doc id  : $docId, dev id : ${getData('device_id')}, response :${response.body} ");
  }

  Future<String> getClient() async {
    var phoneNum = getData("phoneNum");
    var response = await http.post(Uri.parse(clientInfoAddress),
        body: {'phoneNum': encrypt(phoneNum)});
    if (response.statusCode == 403) {
      print("account not found, logging out..");
      logout();
      return "null";
    }
    client.value = Client.fromJson(jsonDecode(response.body));
    remoteServices.fetchData();
    setAccessLevel(phoneNum);
    setData("doctorId", client.value.id);
    return "null";
  }
  AppLifecycleState? _lastLifecycleState;
  void _onStateChanged(AppLifecycleState state) {
    log("_onStateChanged : $state");
    switch (state) {
      case AppLifecycleState.detached:
        {
          print("Lifecycle detached");
          break;
        }
      case AppLifecycleState.resumed:
        {
          _handleResumed();
          break;
        }
      case AppLifecycleState.inactive:
        {
        if (_lastLifecycleState == AppLifecycleState.paused) {
          // App is coming to the foreground
          setData("backgroundTime", DateTime.now().millisecondsSinceEpoch);
          log("bg timestamp updated in inactive state (app going background)");
        }
          print("Lifecycle inactive");
          break;
        }
      case AppLifecycleState.hidden:
        {
          print("Lifecycle hidden");
          break;
        }
      case AppLifecycleState.paused:
        {
         setData("backgroundTime", DateTime.now().millisecondsSinceEpoch);
          print("Lifecycle paused");
          log("bg timestamp updated in paused state");
          break;
        }
    }
    // Update the last lifecycle state
    _lastLifecycleState = state;
  }

  void _handleResumed() async {
      _printResumedDebugDataToConsole();
        // App is going to the background
         if (DateTime.now().millisecondsSinceEpoch -
            (getData("backgroundTime") ?? DateTime.now().millisecondsSinceEpoch) 
           // - 894000 
            >=
        900000) {
          log("--------- calling bio auth auth from resumed --------");
       await AuthinticateWithBiometric();
        }
  }

  void _printResumedDebugDataToConsole() {
        log("Background time stamp now: ${DateTime.now().millisecondsSinceEpoch}, timestamp on device : ${getData("backgroundTime")} ");
        log("background time : ${   ( DateTime.now().millisecondsSinceEpoch  - (getData("backgroundTime") ?? 0))  / 60000} minutes");
        log("If must auth because of 15 mins bg time : " +(DateTime.now().millisecondsSinceEpoch -
                  (getData("backgroundTime") ?? DateTime.now().millisecondsSinceEpoch) >=
              900000)
          .toString());
        log("final if must  authinticate   : " +
      ((DateTime.now().millisecondsSinceEpoch -
                  (getData("backgroundTime") ?? DateTime.now().millisecondsSinceEpoch) >=
              900000))
          .toString());
  }

  Future<bool> AuthinticateWithBiometric() async {
   log("AuthinticateWithBiometric called");
   try {
      LocalAuthentication().stopAuthentication();
      final bool didAuthenticate = await LocalAuthentication().authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions());
           setData("backgroundTime", DateTime.now().millisecondsSinceEpoch);
      return didAuthenticate;
    } catch (e)
     {
      log("Couldn't authenticate with biometric, error : $e");
       logout();
      setData("isLoggedIn", false);
      return false;
       
     }
    
  }

  Future<void> logSignInAction() async {}

  // Future<bool> authenticateIsAvailable() async {
  //   final isAvailable = await localAuth.canCheckBiometrics;
  //   final isDeviceSupported = await localAuth.isDeviceSupported();
  //   return isAvailable && isDeviceSupported;
  // }
}
