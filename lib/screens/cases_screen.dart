import 'dart:developer';

import 'package:app/controllers/notification_contoller.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/utils/storage_service.dart';
import 'package:app/widgets/case_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';

import '../utils/local_auth_service.dart';

class CasesScreen extends StatefulWidget {
  CasesScreen({Key? key, this.tabIndex}) : super(key: key);
  ValueNotifier<int>? tabIndex = ValueNotifier<int>(0);
  static bool? fromNotification;
  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen>
    with SingleTickerProviderStateMixin {
  final remoteServices = Get.find<RemoteServicesController>();
    final NotificationController notificationController = Get.find();
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'In-Progress'),
    const Tab(text: 'Completed'),
  ];
  late Image background;
  TabController? _tabController;
  int initialTabIndex = 0;
  @override
  void initState() {
    super.initState();
    log("notificationController.remoteMessage ${notificationController.remoteMessage}");
    if (notificationController.remoteMessage != null) {
      if (notificationController.remoteMessage!.data["click_action"] == "openCompletedCases")
      initialTabIndex = 1;
    }
 log("initialTabIndexe $initialTabIndex");
    _tabController = TabController(vsync: this, length: myTabs.length,initialIndex: initialTabIndex);
    _tabController?.addListener(() {
      setState(() {});
    });

    checkAuthorization();
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();
    background = Image.asset("assets/images/background3.jpg");

    print(
        'getData("pushedFromANotification": ${getData("pushedFromANotification")}');
    if (getData("pushedFromANotification") !=
        null)
         if (getData("pushedFromANotification") ==
            true ||
        getData("pushedFromANotification") == "true") {
      widget.tabIndex?.value = 1;
      _tabController?.animateTo(1);

      setData("pushedFromANotification", false);
    }
    if (widget.tabIndex == null) widget.tabIndex = ValueNotifier<int>(0);
    widget.tabIndex!.addListener(() {
      _tabController?.animateTo(widget.tabIndex!.value);
      // Do something when _myInt changes
      print('Int changed: ${widget.tabIndex}');
    });
 if (widget.tabIndex?.value == 1)
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _tabController?.animateTo(1);
    });

  }

  @override
  void dispose() {
    widget.tabIndex?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(background.image, context);
    super.didChangeDependencies();
  }

  var refreshKeyCompleted = GlobalKey<RefreshIndicatorState>();
  var refreshKeyProgress = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshListCompleted() async {
    refreshKeyCompleted.currentState?.show(atTop: true);
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }

  Future<Null> refreshListProgress() async {
    refreshKeyProgress.currentState?.show(atTop: true);
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("[cases sccreen build] : tab index: ${widget.tabIndex}");
    print(
        "[cases sccreen build] : from notification ; ${CasesScreen.fromNotification}");
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
            elevation: 0,
            foregroundColor: kWhite,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("CASES"),
            actions: <Widget>[]),
        body: Center(
            child: ValueListenableBuilder<int>(
          valueListenable: widget.tabIndex ?? ValueNotifier<int>(0),
          builder: (context, value, child) {
            return ScreenBody();
          },
        )));
  }

  Container ScreenBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: background.image,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 100.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(kBlack),
                    backgroundColor: WidgetStateProperty.all(
                        _tabController?.index == 0
                            ? kBlue
                            : Color.fromARGB(0, 0, 0, 0)),
                    fixedSize: WidgetStateProperty.all(Size(120.w, 45.h)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                color: _tabController?.index == 0
                                    ? kBlue
                                    : Colors.grey,
                                width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)))),
                  ),
                  onPressed: () {
                    widget.tabIndex?.value = 0;
                    _tabController?.animateTo(0);
                   // setState(() {});
                  },
                  child: Text(
                    "In-Progress",
                    style: TextStyle(
                        fontWeight: _tabController?.index == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.white),
                  )),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(kBlack),
                    backgroundColor: WidgetStateProperty.all(
                        _tabController?.index == 1
                            ? kGreen
                            : Colors.transparent),
                    fixedSize: WidgetStateProperty.all(Size(120.w, 45.h)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                color: _tabController?.index == 1
                                    ? kGreen
                                    : Colors.grey,
                                width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)))),
                  ),
                  onPressed: () {
                    widget.tabIndex?.value = 1;
                    _tabController?.animateTo(1);
                   // setState(() {});
                  },
                  child: Text("Completed",
                      style: TextStyle(
                          fontWeight: _tabController?.index == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.white)))
            ],
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Date",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                  Text("Patient Name",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp))
                ],
              ),
            ),
          ),
          Expanded(
            //height: MediaQuery.of(context).size.height,
            child:

                //  GestureDetector(
                //     excludeFromSemantics: true,
                //     onHorizontalDragEnd: (details) {
                //       if (details.velocity.pixelsPerSecond.dx <
                //           0) // Swipe to left
                //       {
                //         // Minimum distance check
                //         Navigator.pop(context);
                //       }

                TabBarView(controller: _tabController, children: [
              Obx(
                () => RefreshIndicator(
                  // edgeOffset: 300,
                  color: kGreen,
                  displacement: 20,
                  onRefresh: refreshListProgress,
                  key: refreshKeyProgress,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: remoteServices.waitingCases.length,
                    itemBuilder: (context, index) {
                      return CaseTile(
                          caseItem: remoteServices.waitingCases[index],
                          isCompleted: true);
                    },
                  ),
                ),
              ),
              Obx(
                () => RefreshIndicator(
                  onRefresh: refreshListCompleted,
                  key: refreshKeyCompleted,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: remoteServices.completedCases.length,
                    itemBuilder: (context, index) {
                      return CaseTile(
                          caseItem: remoteServices.completedCases[index],
                          isCompleted: false);
                    },
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
