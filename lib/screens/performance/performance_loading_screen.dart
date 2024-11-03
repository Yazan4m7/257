

import 'dart:developer';

import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/screens/performance/performance_screen.dart';
import 'package:app/widgets/show_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/utils/constants.dart';
import 'package:get/get.dart';

class PerformanceLoadingScreen extends StatefulWidget {
  @override
  _PerformanceLoadingScreenState createState() => _PerformanceLoadingScreenState();
}

class _PerformanceLoadingScreenState extends State<PerformanceLoadingScreen>
    with SingleTickerProviderStateMixin {
  final reportsDataController = Get.find<ReportsDataController>();
      initState() {
      
       // reportsDataController.fetchReportsData();
        super.initState();
      }
  TextStyle textStyle = TextStyle(color: kGreen,fontSize: 17.sp,fontWeight: FontWeight.w600);
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 8000), () async{

      await reportsDataController.fetchReportsData();
      
        Navigator.of(context).pushReplacement(MaterialPageRoute (
          builder: (BuildContext context) =>  PerformanceScreen(),
        ));
    });
    return Scaffold(
      backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                      AssetImage("assets/images/gifs/performance_bg2.gif"),
                      opacity: 1,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 95,
              //   right:155,
              //   child: Container(
              //     width: 50.w,
              //     height: 60.h,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image:
              //         AssetImage("assets/images/logo_small.png"),
              //
              //         opacity: 0.7,
              //         fit: BoxFit.fitHeight,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned.fill(
                  top: 280.h,
                  child: Container(

                      width: 300.w,
                      height: 600.h,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            SizedBox(height: 80.h,),
                            // LoadingAnimationWidget.dotsTriangle(
                            //   color: kGreen,
                            //   size: 50,
                            // ),
                            SizedBox(height: 120.h,),
                            ShowUp(child: Text("Analyzing your data....",style: textStyle.copyWith(fontSize: 23.sp),), delay: 200),
                            SizedBox(height:20.h),
                            ShowUp(child: Text("Please Wait",style: textStyle.copyWith(fontSize: 23.sp,fontWeight: FontWeight.w400),), delay: 200),
                            // ShowUp(child: Text("Units amounts ...",style: textStyle,), delay: 850),
                            // ShowUp(child: Text("Job Types ...",style: textStyle,), delay: 2300),
                            // ShowUp(child: Text("Quality Control Data ...",style: textStyle,), delay: 2600),
                            // ShowUp(child: Text("Implants ...",style: textStyle,), delay: 3100),
                            // ShowUp(child: Text("Completed, Redirecting.. ...",style:textStyle,), delay: 3600),
                          ],
                        ),
                      )))
            ])));
  }
}
