import 'package:app/screens/performance/performance_loading_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/screens/cases_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';
import '../utils/local_auth_service.dart';
import 'account_statement.dart';
import 'package:app/models/client.dart';
import 'package:app/utils/storage_service.dart';
import 'gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final remoteServices = Get.find<RemoteServicesController>();
  String? appName, packageName, version, buildNumber = "";
  Client? client;

  void updateFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    RemoteServicesController.instance.setNotificationToken(fcmToken!);
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("FCM Token Refreshed : $fcmToken");
      RemoteServicesController.instance.setNotificationToken(fcmToken);
    }).onError((err) {
      print("Error getting fcm token");
    });
  }

  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
              //       decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/AI/ (1).png"),
              //     fit: BoxFit.fitHeight,
              //     opacity: 0.2
              // ),

              // ),

              ),

          // Positioned(
          //     right: 45.w,
          //     top: 29.h,
          //     child: _buildClientName()),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 100.h,
                child: AppBar(
                  leading: SizedBox(),
                  elevation: 0,
                  foregroundColor: kWhite,
                  backgroundColor: Colors.transparent,
                  actions: <Widget>[
                    PopupMenuButton(
                      color: Color(0xffa6a6a6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      // add icon, by default "3 dot" icon
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white70,
                      ),
                      iconSize: 40.w,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            padding: EdgeInsets.only(left: 0.w, right: 0),
                            value: 0,
                            child: Center(child: _buildClientName()),
                          ),
                          PopupMenuItem<int>(
                              height: 2.h,
                              value: 0,
                              child: Container(
                                color: Colors.black54,
                                height: 1.h,
                              )),
                          PopupMenuItem<int>(
                              height: 2.h,
                              value: 0,
                              child: Container(
                                color: Colors.black54,
                                height: 1.h,
                                width: 100.w,
                              )),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                    fontSize: main_btns_text_size,
                                    color: Colors.black,
                                    fontFamily: 'Quest'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 1) {
                          print("Logout");
                          authController.logout();
                        }
                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " د. ",
                    style: TextStyle(
                      fontSize: main_btns_text_size,
                      color: Colors.transparent,
                      fontFamily: 'Quest',
                    ),
                  )
                ],
              ),
              SizedBox(height: 50.h),
              _buildLogo(),
              SizedBox(height: 100.h),
              //_buildClientName(),
              SizedBox(height: 50.h),
              _buildCasesBtn(),
              SizedBox(height: 25.h),
              Obx(
                () => authController.isDoctorAccount.value
                    ? _buildAccountStatementBtn()
                    : SizedBox(),
              ),
              SizedBox(height: 25.h),
              Obx(() => authController.isDoctorAccount.value
                  ? _buildGalleryBtn()
                  : SizedBox()),
              SizedBox(height: 25.h),
              Obx(() => authController.isDoctorAccount.value
                  ? _buildPerformanceBtn()
                  : SizedBox()),
            ],
          ),
          // Positioned(left:0,bottom:0,child: _buildAccessLevelTag()),
            Positioned(left:15,bottom:0,child: _buildVersionCode()),
        ],
      ),
    );
  }

  @override
  void initState() {
    updateFCMToken();
    checkIfAllMediaViewed();
    remoteServices.getGalleryItems();
    getVersionCode();
    setupInteractedMessage();
    super.initState();
    checkAuthorization();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) async {
    print("Handling a background message in main screen: ${message.data}");
    if (message.data["click_action"] == "openCompletedCases") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CasesScreen(tabIndex: ValueNotifier<int>(1)),
        ),
      );
    }
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();

    if (message.data["click_action"] == "OpenAccountStatement") {
      await remoteServices.getStatement();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AccountStatementScreen(),
        ),
      );
    }
  }

  void getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  @override
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
    );
  }

  Widget _buildClientName() {
    return Obx(
      () => Text(
        " د. " + (authController.client.value.name ?? ""),
        style: TextStyle(
          fontSize: main_btns_text_size,
          color: Colors.black,
          fontFamily: 'Quest',
        ),
      ),
    );
  }

  Widget _buildCasesBtn() {
return TextButton(
      
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(kGreen),
          foregroundColor: WidgetStateProperty.all(kWhite),
          fixedSize: WidgetStateProperty.all(Size(250.w, 45.h)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ))),
          overlayColor: WidgetStateProperty.all(Colors.green[200]), 
          
        ),
        
        onPressed: () {
          // Navigator.of(context).push(
          //   CustomMaterialPageRoute(
          //       canOnlySwipeFromEdge: false,
          //   builder: (BuildContext context) => CasesScreen(),
          // ));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CasesScreen(),
            ),
          );
        },
        child: Text(
          "CASES",
          style:
              TextStyle(fontSize: main_btns_text_size, fontFamily: fontFamily),
        ));
  }

  Widget _buildAccountStatementBtn() {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(kGreen),
          foregroundColor: WidgetStateProperty.all(kWhite),
          fixedSize: WidgetStateProperty.all(Size(250.w, 45.h)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            
          ))),
              overlayColor: WidgetStateProperty.all(Colors.green[200]), 
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AccountStatementScreen(),
          ));
        },
        child: Text(
          "ACCOUNT STATEMENT",
          style:
              TextStyle(fontSize: main_btns_text_size, fontFamily: fontFamily),
        ));
  }

  Widget _buildGalleryBtn() {
    return Container(
      width: 250.w,
      height: 45.h,
      child: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: TextButton(
              style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.green[200]), 
                backgroundColor: WidgetStateProperty.all(kGreen),
                foregroundColor: WidgetStateProperty.all(kWhite),
                fixedSize: WidgetStateProperty.all(Size(250.w, 45.h)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ))),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GalleryScreen(),
                ));
              },
              child: Text(
                "GALLERY",
                style: TextStyle(
                    fontSize: main_btns_text_size, fontFamily: fontFamily),
              )),
        ),
        Obx(
          () => remoteServices.isAllMediaViewed.value
              ? SizedBox()
              : Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/new_badge_circle.png",
                    width: 35.w,
                  )),
        )
      ]),
    );
  }

  Widget _buildAccessLevelTag() {
    return Positioned(
        bottom: 10.h,
        left: 15.w,
        child: Obx(
          () => Text(
            authController.isDoctorAccount.value
                ? "Doctor Account"
                : "Clinic Account",
            style: TextStyle(color: kGrey, fontFamily: fontFamily),
          ),
        ));
  }

  Widget _buildVersionCode() {
    return Text(
      "v $version.$buildNumber",
      style: TextStyle(color: kGrey, fontFamily: fontFamily),
    );
  }

  Widget _buildPerformanceBtn() {
    return Container(
      width: 250.w,
      height: 45.h,
      child: TextButton(
          style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.green[200]), 
            backgroundColor: WidgetStateProperty.all(kGreen),
            foregroundColor: WidgetStateProperty.all(kWhite),
            fixedSize: WidgetStateProperty.all(Size(250.w, 45.h)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ))),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => PerformanceLoadingScreen(),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
                transitionDuration: Duration(milliseconds: 1000),
              ),
            );
            //   Navigator.of(context).push(MaterialPageRoute(
            //     builder: (BuildContext context) => PerformanceLoadingScreen(),
            //   ));
          },
          child: Text(
            "MY PERFORMANCE",
            style: TextStyle(
                fontSize: main_btns_text_size, fontFamily: fontFamily),
          )),
    );
  }
}
