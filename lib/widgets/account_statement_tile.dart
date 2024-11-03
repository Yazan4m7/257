import 'package:app/controllers/remote_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/models/job.dart';
import '../models/AccountStatementEntry.dart';
import '../utils/constants.dart';

class AccountStatementTile extends StatefulWidget {
  final AccountStatementEntry? entry;
  final double? balance;

  const AccountStatementTile({Key? key, this.entry, this.balance})
      : super(key: key);

  @override
  State<AccountStatementTile> createState() => _AccountStatementTileState();
}

class _AccountStatementTileState extends State<AccountStatementTile> {
  @override
  Widget build(BuildContext context) {
    String year,day,  month, hour;
    Jiffy jiffyDate = Jiffy.parse(widget.entry!.createdAt!).add(hours: 3);
    year = jiffyDate.year.toString();
    day = jiffyDate.date.toString();
    month = jiffyDate.MMM.toString();
    hour = jiffyDate.jm.toString();
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
    );
    int entryTitleLength = 0;
    if (widget.entry!.patientName != null)
      entryTitleLength = widget.entry!.patientName!.length;
    else
      entryTitleLength = 0;

    Future<List<job>> _fetchJobs() async {
      List<job> jobs = await RemoteServicesController.instance
          .getJobs(widget.entry!.caseId.toString());
      return jobs;
    }

    initState() {
      _fetchJobs();
      super.initState();
    }

    return GestureDetector(
      onTap: () {
        // PAYMENT DIALOG
        if (widget.entry!.collector != null)
        {
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
                        Text("PAYMENT", style: TextStyle(fontSize: 18.sp,fontFamily: fontFamily)),
                        const Divider(),
                        Text(
                          "${formatter.format(widget.entry!.amount!) ?? " N/A "} JOD",
                          style: TextStyle(
                              fontSize: 26.sp, fontWeight: FontWeight.bold,fontFamily: fontFamily),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text("Paid On: ",style:TextStyle(fontFamily: fontFamily)),
                            Text("$month-$day, $hour",
                                style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily))
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payment Method: ",style:TextStyle(fontFamily: fontFamily)),
                            Text(
                                "${widget.entry!.fromBank == null ? "CASH" : "Cheque"}",
                                style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily))
                          ],
                        ),

                        widget.entry!.fromBank != null ? Column(
                          children: [
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(overflow: TextOverflow.ellipsis,"Cheque Details: ",style:TextStyle(fontFamily: fontFamily)),
                                Text(
                                    "${widget.entry!.notes?.replaceAll("شيك", '').trim()}",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily))
                              ],
                            ),
                          ],
                        ) : const SizedBox(height:1),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Collector: ",style:TextStyle(fontFamily: fontFamily)),
                            Text(
                              " ${RemoteServicesController.instance.employees[widget.entry?.collector]?.nameInitials}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily),
                            ),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('CLOSE'),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  );
                },
              );

        }
        // DISCOUNT DIALOG
        else if (widget.entry!.discountTitle != null)
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("DISCOUNT", style: TextStyle(fontSize: 18.sp,fontFamily: fontFamily)),
                    const Divider(),
                    Text(
                      "${widget.entry!.discountTitle! ?? " N/A "}",
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold,fontFamily: fontFamily),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount: ",style:TextStyle(fontFamily: fontFamily)),
                        Text("${formatter.format(widget.entry!.amount!) ?? " N/A "} JOD",
                            style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily))
                      ],
                    ),SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date: "),
                        Text("$month  $hour",
                            style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontFamily))
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('CLOSE'),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center,
              );
            },
          );
        }
        // INVOICE DIALOG
        else
        {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("INVOICE", style: TextStyle(fontSize: 18.sp,fontFamily: fontFamily)),
                      const Divider(),
                      Text(
                        
                        widget.entry!.patientName ?? " N/A ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.bold,fontFamily: fontFamily),
                      ),
                      Text("Delivered on $month $day,  $hour",textAlign: TextAlign.center,style:TextStyle(fontSize:16.sp,fontFamily: fontFamily)),
                      SizedBox(height: 0.h),
                      FutureBuilder<List<job>>(
                        future: _fetchJobs(), // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<job>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();
                            default:
                              if (snapshot.hasError) {
                                print('Error: ${snapshot.error}');
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height:50,
                                      child: DataTable(

                                        columnSpacing: 5.w,
                                        horizontalMargin: 0,
                                        columns: [
                                          DataColumn(
                                              label: Container(
                                                width:70,
                                                child: Text('Type',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                        FontWeight.bold,fontFamily: fontFamily,height: 4)),
                                              )),
                                          DataColumn(
                                              label: Container(
                                                width:80,
                                                child: Text('Material',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                        FontWeight.bold,fontFamily: fontFamily,height: 4)),
                                              )),
                                          DataColumn(
                                              label: Container(
                                                width:30,
                                                child: Text('Qty',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                        FontWeight.bold,fontFamily: fontFamily,height: 4)),
                                              )),
                                          DataColumn(
                                            label: Container(
                                              width:55,
                                              child: Text('Total',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.bold,fontFamily: fontFamily,height: 4)),
                                            ),
                                          )
                                        ],
                                        rows: [

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:snapshot.data!.length > 8 ? 8*50 :snapshot.data!.length * 50,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(

                                          columnSpacing: 5.w,
                                          horizontalMargin: 0,
                                          headingRowHeight: 0,
                                          columns: [
                                            DataColumn(label: Container()),
                                            DataColumn(label: Container()),
                                            DataColumn(label: Container()),
                                            DataColumn(label: Container()),
                                          ],
                                          rows: [
                                            for (var job in snapshot.data!)
                                              // TODO: Handle Rejection Cases
                                              //if(job.hasBeenRejected == 1) continue;
                                              DataRow(cells: [
                                                DataCell(Container(
                                                    width: 75.w,
                                                    child: Text(job.jobType!,style:TextStyle(fontFamily:fontFamily,height: 1)))),
                                                DataCell(Container(
                                                    width: 75.w,
                                                    child: Text(job.material!,style:TextStyle(fontFamily: fontFamily,height: 1)))),
                                                DataCell(Container(
                                                    width: 30.w,
                                                    child:
                                                    Text(job.qty.toString(),textAlign: TextAlign.center,style:TextStyle(fontFamily: fontFamily)))),
                                                DataCell(Container(
                                                    width: 55.w,
                                                    child: Text(
                                                        job.total.toString(),textAlign: TextAlign.center,style:TextStyle(fontFamily: fontFamily))))
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
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Total: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 3.w)),
                              child: Text(
                                  "${formatter.format(widget.entry!.amount)} JOD" ?? "N/A",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,fontFamily: fontFamily))),
                        ],
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('CLOSE'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.start,
                );
              },
            );
          }
      },

      // Account Statement Tile
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h,left:5.w,right:5.w),
        decoration: BoxDecoration(
            color: kAccountStatementTileBGColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 350.w,
        height: 60.h,
        child: Stack(
          children: [
            Positioned(
                top: 10.h,
                left: 15.w,
                child: Text("$month $day", style: TextStyle(fontSize: 16.sp,color:kAccountStatementForegroundColor,fontFamily: fontFamily))),
            Positioned(top: 30.h, left: 15.w, child: Text(hour ?? "-",style: TextStyle(color:kAccountStatementForegroundColor,fontFamily: fontFamily),)),
            Positioned(
                top: 0.h,
                left: 100.w,
                child: Container(
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Container(
                      width: 100.w,

                      child: Text(
                        
                          widget.entry!.patientName ??
                              ((widget.entry!.caseId == 0 && widget.entry!.discountTitle != null)
                                  ? widget.entry!.discountTitle!
                                  : "Payment"),
                          style: TextStyle(color: kAccountStatementForegroundColor, fontSize: 15.sp,fontFamily: fontFamily),
                          overflow: TextOverflow.ellipsis,  
                          ))],),
                )),
            Positioned(
                top: 20.h,
                left: 220.w,
                child: Text(formatter.format(widget.entry!.amount) ?? "",
                    style: TextStyle(
                        color: widget.entry!.patientName == null
                            ? kGreen
                            : kAccountStatementForegroundColor,
                        fontSize: 16.sp,fontFamily: fontFamily))),
            Positioned(
                top: 20.h,
                right: 30.w,
                child: Text(formatter.format(widget.balance!) ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp,color:kAccountStatementForegroundColor,fontFamily: fontFamily)))
          ],
        ),
      ),
    );
  }
}
