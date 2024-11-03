import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QualityControlPerformance extends StatefulWidget {
  const QualityControlPerformance({Key? key}) : super(key: key);

  @override
  State<QualityControlPerformance> createState() =>
      _QualityControlPerformanceState();
}
final reportsDataController = Get.find<ReportsDataController>();
class _QualityControlPerformanceState extends State<QualityControlPerformance> {
  @override
  Widget build(BuildContext context) {

    int successfulUnits = reportsDataController.QCCounts[0]-reportsDataController.QCCounts[1];
    int repeatedUnits = reportsDataController.QCCounts[1];
    int percentage = 0;
    if(successfulUnits+repeatedUnits != 0)
    percentage = (successfulUnits/(successfulUnits+repeatedUnits)*100).toInt();



    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(children: [
          SizedBox(height: 35.h,),
          Padding(
            padding:
            const EdgeInsets.only(top: 25.0, left: 18.0, right: 18.0),
            child: Text(
              "QUALITY CONTROL",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),

      SizedBox(
        height: mediaQuery.height / 2.1 - 90,
        width: mediaQuery.width ,
        child: SfRadialGauge(
          // title: GaugeTitle(text: "81%",alignment: GaugeAlignment.values[1]),
            enableLoadingAnimation: true, animationDuration: 2000,
            axes: <RadialAxis>[
      RadialAxis(

        labelFormat: "{value}%",
        startAngle: 180,
        endAngle: 0,
        interval: 10,
        canScaleToFit: true,
        pointers: <GaugePointer>[

          RangePointer(value: percentage.toDouble(), width: 0.2,
            color: Colors.green,
            sizeUnit: GaugeSizeUnit.factor
        ),NeedlePointer(value: percentage.toDouble(),)
        ],
        axisLineStyle: AxisLineStyle(
          thickness: 0.2,
          thicknessUnit: GaugeSizeUnit.factor,
         color: Colors.red),
      )]),
      ),
      Text("Successful Rate"),
      Text(percentage.toString() +"%",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w700,color: kGreen),),
      SizedBox(height: 25.h,),
      Expanded(
        child: Column(

              children:[
                SizedBox(height: 100.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Text(
                            String.fromCharCode(CupertinoIcons.check_mark.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.green,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: CupertinoIcons.check_mark.fontFamily,
                              package: CupertinoIcons.check_mark.fontPackage,
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Text("SUCCESSFUL",style: TextStyle(color: Colors.black,fontSize: 17.sp,fontWeight:FontWeight.w600),)
                        ],
                      ),
                      SizedBox(height:10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(successfulUnits.toString(),style: TextStyle(color: Colors.green,fontSize: 24.sp,fontWeight: FontWeight.w700),),
                          Text(" UNITS",style: TextStyle(color: Colors.black54,fontSize: 17.sp),),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            String.fromCharCode(CupertinoIcons.repeat.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.red,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: CupertinoIcons.check_mark.fontFamily,
                              package: CupertinoIcons.check_mark.fontPackage,
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Text("REPEATED",style: TextStyle(color: Colors.black,fontSize: 17.sp,fontWeight:FontWeight.w600),)
                        ],
                      ),
                      SizedBox(height:10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(repeatedUnits.toString(),style: TextStyle(color: Colors.red,fontSize: 24.sp,fontWeight: FontWeight.w700),),
                          Text(" UNITS",style: TextStyle(color: Colors.black54,fontSize: 17.sp),),
                        ],
                      )
                    ],
                  ),
                ),

        ]),
      ),
    ]));
  }
}
