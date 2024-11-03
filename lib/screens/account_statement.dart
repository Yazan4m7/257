import 'dart:developer';

import 'package:app/models/AccountStatementEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';
import '../utils/local_auth_service.dart';
import '../widgets/account_statement_tile.dart';
import 'package:get/get.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({Key? key}) : super(key: key);

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  final authController = Get.find<AuthController>();
  final remoteServices = Get.find<RemoteServicesController>();
  final ScrollController _scrollController = ScrollController();
  double? openingBalance = 0;
  bool isLoadingOpeningBalance = true;
  bool isLoadingAccountStatement = true;
  bool scrolledDown = false;
  int prevAccountStatementEntriesLength = 0;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );
   bool _isScrollingDown = false;
  late final AppLifecycleListener _listener;
  @override
  void initState() {
      
      remoteServices.entries.listen((value) {
        print("Account prev count: $prevAccountStatementEntriesLength  ${value[remoteServices.date.value.yMMM]?.length} xx");
        log("Account statement entries listener fired ${value.length} xx");
        if (prevAccountStatementEntriesLength != value[remoteServices.date.value.yMMM]?.length) {
          
          log("------- SCROLLING DOWN FROM LISTNER -------");
          log(_isScrollingDown.toString());
        if(!_isScrollingDown) 
        {
            log("_isScrollingDown" + _isScrollingDown.toString());
           scrolledDown = false;
            _scrollDown(1500,400);
        } 
    
         prevAccountStatementEntriesLength = value[remoteServices.date.value.yMMM]?.length ?? 0;
           }
           
       
      });
    //     _listener = AppLifecycleListener(
    //   onStateChange: (state) {
    //     print("ACCOUNT STATEMENT AppLifecycleListener $state");
    //     if (state == AppLifecycleState.resumed) {
    //       Future.delayed(Duration(milliseconds: 1000)).then((value) {
    //          scrolledDown = false;
    //         print("scrolling..........");
    //           _scrollDown();
    //       });
          
    //     }
    //   },
    // );
    remoteServices.getStatement();
    remoteServices.getCurrentBalance();
    checkAuthorization();
    super.initState();
  }

  void _scrollDown([int? scrollingDuration = 800, int? delay = 1000]) {
    _isScrollingDown = true;
       log("Scroll down called");
    if (!scrolledDown) {
      Future.delayed(Duration(milliseconds: delay ?? 800)).then((value)async {
        log("Future.delay");
        if (_scrollController.positions.isNotEmpty  ){
            log("animating down");
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: scrollingDuration ?? 800),
            curve: Curves.fastOutSlowIn,
          );}
           _isScrollingDown = false;
      });
      scrolledDown = true;
    
    }
  }
    Future<Null> refreshAccountstement() async {

    remoteServices.getStatement();
    remoteServices.getCurrentBalance();
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }
@override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
     precacheImage(const AssetImage("assets/images/background3.jpg"), context);
  }
  @override
  Widget build(BuildContext context) {
    double balance = double.parse(remoteServices.openingBalance.value);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
    
        body: Stack(
          children: [
            Container(
                  decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPath),
              fit: BoxFit.cover,
            ),
                  ),
                  child: Stack(children: [
            
            Positioned.fill(
                top: 40.h,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => remoteServices.date.value.yMMM ==
                                  Jiffy.now().subtract(months: 1).yMMM
                              ? SizedBox(width: 15.w)
                              : IconButton(
                                  onPressed: () {
                                    double balance = double.parse(
                                        remoteServices.openingBalance.value);
                                    remoteServices.previousMonth();
                                    scrolledDown = false;
                                    _scrollDown();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  )),
                        ),
                        Obx(
                          () => Text(remoteServices.date.value.yMMM,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Obx(
                          () => remoteServices.date.value.yMMM == Jiffy.now().yMMM
                              ? SizedBox(width: 15.w)
                              : IconButton(
                                  onPressed: () {
                                    remoteServices.nextMonth();
                                    scrolledDown = false;
                                    _scrollDown();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  )),
                        ),
                      ],
                    ))),
            Positioned.fill(
              top: 100.h,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [
                          0.0,
                          0.1,
                          0.3,
                          0.7,
                          0.9,
                          1.0,
                        ],
                        colors: [
                          kAccountStatementTileBGColor.withOpacity(0.00),
                          kAccountStatementTileBGColor.withOpacity(0.05),
                          kAccountStatementTileBGColor,
                          kAccountStatementTileBGColor,
                          kAccountStatementTileBGColor.withOpacity(0.05),
                          kAccountStatementTileBGColor.withOpacity(0.00),
                        ],
                      ),
                      //color: kAccountStatementTileBGColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: 300.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.center,
                      spacing: 20.w,
                      runSpacing: 20.h,
            
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("Current Balance",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kAccountStatementForegroundColor)),
                            SizedBox(height: 5.h),
                            Obx(
                              () => Text(
                                  formatter.format(double.parse(
                                      remoteServices.currentBalance.value)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.sp,
                                      color: double.parse(remoteServices
                                                  .currentBalance.value) <
                                              1
                                          ? kGreen
                                          : Colors.redAccent)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 200.h,
              child: Column(children: [
                SizedBox(height: 5.h),
                Expanded(
                  child: Container(
                    height: 550.h,
                    child: Obx(
                      () => ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount:
                            remoteServices.entries[remoteServices.date.value.yM] ==
                                    null
                                ? 1
                                : remoteServices
                                        .entries[remoteServices.date.value.yM]!
                                        .length +
                                    1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            balance =
                                double.parse(remoteServices.openingBalance.value);
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: 10.h, left: 5.w, right: 5.w),
                              decoration: BoxDecoration(
                                  color: kAccountStatementTileBGColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: 350.w,
                              height: 60.h,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 20.h,
                                      left: 10.w,
                                      child: Text(
                                        "Opening Balance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color:
                                                kAccountStatementForegroundColor),
                                      )),
                                  Positioned(
                                    top: 20.h,
                                    right: 30.w,
                                    child: Obx(
                                      () => Text(
                                        formatter.format(double.parse(remoteServices
                                                .openingBalance.value) ??
                                            0),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color:
                                                kAccountStatementForegroundColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (!scrolledDown) if (remoteServices
                                      .entries[remoteServices.date.value.yM] !=
                                  null &&
                              index == 4) {
                            _scrollDown();
                          }
                          AccountStatementEntry? entry = remoteServices
                              .entries[remoteServices.date.value.yM]?[index - 1];
                          if (entry?.status == 1) {
                            balance += entry?.amount ?? 0;
                          } else {
                            balance -= entry?.amount ?? 0;
                          }
                          if (entry != null) {
                            return AccountStatementTile(
                                entry: entry, balance: entry.balance);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                )
              ]),
            ),
                  ]),
                ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: MediaQuery.of(context).size.width/30,
            child:   IconButton(
          icon:Icon(Icons.arrow_back_ios),color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),),
          ],
        ));
  }
}
