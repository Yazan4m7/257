import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/remote_services_controller.dart';
import '../models/case.dart';
import '../models/job.dart';
import '../utils/constants.dart';

class CaseTile extends StatelessWidget {
  final Case caseItem;
  final bool isCompleted;
  const CaseTile({Key? key, required this.caseItem, required this.isCompleted})
      : super(key: key);
  double percentageCompleted() {
    DateTime createdAt = DateTime.parse(caseItem.createdAt!);
    DateTime deliveryTime = DateTime.parse(caseItem.initialDeliveryDate!);
    DateTime now = DateTime.now();
    Duration hoursToCompleteCase = deliveryTime.difference(createdAt);
    Duration timeElapsed = now.difference(createdAt);
    return ((timeElapsed.inHours) / (hoursToCompleteCase.inHours));
  }

  @override
  Widget build(BuildContext context) {
    String year, month, day, hour;
    Jiffy jiffyDate = Jiffy.parse(caseItem.actualDeliveryDate == null
        ? caseItem.initialDeliveryDate!
        : caseItem.actualDeliveryDate!);
    year = jiffyDate.year.toString();
    month = jiffyDate.month.toString();
    day = jiffyDate.MMMMd.toString();
    hour = jiffyDate.jm.toString();

    bool isNew = Jiffy.now().yMMMMd ==
        Jiffy.parse(caseItem.deliveredToClient == 1
                ? (caseItem.actualDeliveryDate != null ? caseItem.actualDeliveryDate! : caseItem.initialDeliveryDate!) : caseItem.createdAt!).yMMMMd;

    Future<List<job>> _fetchJobs() async {
      List<job> jobs = await RemoteServicesController.instance
          .getJobs(caseItem.id.toString());
      return jobs;
    }
    double percentage=0;
    double progressBarWidth=0;
    if(isCompleted){
     percentage = percentageCompleted();
     progressBarWidth = 353.w * percentage;

    }
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),color: Colors.transparent
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
        margin: EdgeInsets.only(bottom: 10.h,left:5.w,right:5.w),
        width: 200.w,
        height: 65.h,
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
              color: isCompleted ? kCasesTileBGColor : kGreen.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: isCompleted ? kBlue : kGreen, width: 0.w)),
          child: Stack(
            children: [


              isCompleted
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(

                            //border: Border(right: BorderSide(color: isCompleted ?kBlue: kGreen  , width: 5))
                            ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            width: 345.w,
                            animation: true,
                            lineHeight: 58.w,
                            animationDuration: 1500,
                            percent: percentage > 1
                                ? 1
                                : (percentage < 0 ? 1 : percentage),
                            //center: Text("80.0%"),
                            //linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: kCasesTileBGColor,
                            progressColor: kBlue.withOpacity(0.9),
                            //barRadius: Radius.circular(10),
                          ),
                        ),
                      ))
                  : SizedBox(),
              isCompleted
                  ? Positioned(
                  top: 0,
                  left: 0,
                  child: Shimmer.fromColors(
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.only(topLeft:Radius.circular(20),bottomLeft:Radius.circular(20) ),
                        child: Container(
                          color:Colors.blue,
                          width: progressBarWidth <0 ? 343.w :progressBarWidth,
                          height: 60.h,

                        ),),
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white.withOpacity(0.3)))
                  : SizedBox(),
              ( caseItem.deliveredInBox ==1)?
              Positioned(
                top:10.h,
                  left:120.w,

                  child: Image.asset("assets/images/gifs/animated_box.gif",width: 32.w,))
                  :SizedBox()
              ,
              Positioned(
                  top: 9.h,
                  left: 15.w,
                  child: Text(
                    day,
                    style: TextStyle(
                        color: kCasesForegroundColor, fontFamily: fontFamily),
                  )),
              Positioned(
                  top: 27.h,
                  left: 15.w,
                  child: Text(hour,
                      style: TextStyle(
                          color: kCasesForegroundColor,
                          fontFamily: fontFamily))),
              Positioned(
                  top: 15.h,
                  right: isNew ? 19.w : 15.w,
                  child: Container(
                      width: MediaQuery.of(context).size.width *( caseItem.deliveredInBox ==1? 0.43: 0.55),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                      caseItem.patientName ?? "Name Unavailable",
                         textAlign: TextAlign.right,
                        style: TextStyle(
                         
                          overflow: TextOverflow.ellipsis,
                            fontSize: 17,
                            color: kCasesForegroundColor,
                            fontFamily: fontFamily),
                      ),
                    ),
                  )),
              isNew
                  ? Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                      width: 40.w,
                      child: Image.asset(
                        isCompleted
                            ? "assets/images/new_badge.png"
                            : "assets/images/today_badge.png",
                      )))
                  : SizedBox(),
            ],
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Case Details",
                      style:
                          TextStyle(fontSize: 18.sp, fontFamily: fontFamily)),
                  const Divider(),
                  Text(
                    caseItem.patientName ?? " N/A ",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily),
                  ),
                  Center(
                    child: Text(
                        (caseItem.deliveredToClient == 1
                                ? "Delivered on "
                                : "Delivery date: ") +
                            "$day - $hour",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16.sp, fontFamily: fontFamily)),
                  ),
                  SizedBox(height: 20.h),
                  FutureBuilder<List<job>>(
                    future: _fetchJobs(), // async work
                    builder: (BuildContext context,
                        AsyncSnapshot<List<job>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Loading....');
                        default:
                          if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                            return Text('Error: ${snapshot.error}');
                          } else {

                            return Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: DataTable(
                                    dataRowHeight: 55.h,
                                    columnSpacing: 5.w,
                                    horizontalMargin: 0,
                                    columns: [
                                      DataColumn(
                                          label: Container(
                                        width: 100.w,
                                        child: Text('Type',
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontFamily)),
                                      )),
                                      DataColumn(
                                          label: Container(
                                        width: 100.w,
                                        child: Text('Material',
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontFamily)),
                                      )),
                                      DataColumn(
                                          label: Container(
                                        width: 50.w,
                                        child: Center(
                                          child: Text(
                                            'Qty',
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontFamily),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      )),
                                    ],
                                    rows: [],
                                  ),
                                ),
                                SizedBox(
                                  height: snapshot.data!.length > 8
                                      ? 8 * 50
                                      : snapshot.data!.length * 50,
                                  child: SingleChildScrollView(
                                    //scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      dataRowHeight: 55.h,
                                      columnSpacing: 5.w,
                                      horizontalMargin: 0,
                                      headingRowHeight: 0,
                                      columns: [
                                        DataColumn(label: Container()),
                                        DataColumn(label: Container()),
                                        DataColumn(label: Container()),
                                      ],
                                      rows: [
                                        for (var job in snapshot.data!)
                                          DataRow(cells: [
                                            DataCell(Container(
                                                width: 100.w,
                                                child: Text(job.jobType!,
                                                    style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        height: 1)))),
                                            DataCell(Container(
                                                width: 100.w,
                                                child: Text(job.material!,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontFamily)))),
                                            DataCell(Container(
                                                width: 50.w,
                                                child: Text(job.qty.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontFamily)))),
                                          ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
