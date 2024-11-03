import 'dart:developer';

import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/unit_count_model.dart';

class UnitsCountsPerformance extends StatefulWidget {
  const UnitsCountsPerformance({Key? key}) : super(key: key);

  @override
  State<UnitsCountsPerformance> createState() => _UnitsCountsPerformanceState();
}

CircularSeriesController? _chartSeriesController;
TextStyle textStyle = TextStyle(
  color: Colors.black,
  fontSize: 15.sp,
  fontWeight: FontWeight.w900,
);
TextStyle titleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15.sp,
  fontWeight: FontWeight.w400,
);
late Size screenSize;
late List<UnitCount> chartData;
final reportsDataController = Get.find<ReportsDataController>();

class _UnitsCountsPerformanceState extends State<UnitsCountsPerformance> {
  int total = 0;
  @override
  void initState() {
    if (reportsDataController.unitsCounts.isEmpty){
      log( "units counts empty");
reportsDataController.unitsCounts = List.generate(40, (index) {
  return {index + 1: 0};
}).obs;
}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("reportData: ${reportsDataController.unitsCounts.toString()}");
    total = 0;
    screenSize = MediaQuery.of(context).size;
    chartData = [
      UnitCount(
          "Zircon", reportsDataController.unitsCounts[0]["1"] ?? 0, kGreen),
      UnitCount(
          "Emax", reportsDataController.unitsCounts[1]["2"] ?? 0, Colors.blue),
      UnitCount("ACRYLIC", reportsDataController.unitsCounts[2]["3"] ?? 0,
          Color.fromRGBO(251, 2, 210, 1.0)),
      UnitCount("NIGHT GUARD", reportsDataController.unitsCounts[4]["5"] ?? 0,
          Color.fromRGBO(255, 115, 0, 1)),
      UnitCount("CUSTOMIZED ABUT", reportsDataController.unitsCounts[16]["17"]?? 0,
          Color.fromRGBO(232, 186, 17, 1.0)),
      UnitCount(
          "FRAME TITANIUM",
          reportsDataController.unitsCounts[17]["18"] ?? 0,
          Color.fromRGBO(134, 134, 147, 1.0)),
      UnitCount("Emax CAD", reportsDataController.unitsCounts[18]["19"] ?? 0,
          Color.fromRGBO(8, 234, 227, 1.0)),
      UnitCount(
          "DIGITAL DENTURE",
          reportsDataController.unitsCounts[20]["21"] ?? 0,
          Color.fromRGBO(255, 2, 35, 1.0)),
    ];

    chartData.forEach((element) {
      total += element.value;
    });

    return SizedBox.expand(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(0)),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Column(children: [
                  SizedBox(
                    height: 35.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 18.0, right: 18.0),
                    child: Text(
                      "UNITS COUNT",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    // color: Colors.red,
                    height: screenSize.height / 3.1,
                    width: screenSize.width,
                    child: _buildDoughnutCustomizationChart(),
                  ),
                  //Container(color: Colors.green,height: 100,),
                ]),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.6,
                  left: 5,
                  child: Container(
                    // color: Colors.green,
                    height: 600.h,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: chartData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildDescRow(chartData[index].unitName,
                            chartData[index].value, chartData[index].color);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  SfCircularChart _buildDoughnutCustomizationChart() {
    return SfCircularChart(
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
            widget: Text(total.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.w900)))
      ],
      series: _getDoughnutCustomizationSeries(),
    );
  }
}

_buildDescRow(String unitName, int amount, Color iconColor) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 0),
    height: screenSize.height / 27,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.circle_rounded, color: iconColor),
              ),
              Text(unitName.toUpperCase(), style: titleTextStyle),
            ],
          ),
          Text(amount.toString(), style: textStyle)
        ],
      ),
    ),
  );
}

List<DoughnutSeries<UnitCount, String>> _getDoughnutCustomizationSeries() {
  TextStyle style = TextStyle(
      color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600);

  return <DoughnutSeries<UnitCount, String>>[
    DoughnutSeries<UnitCount, String>(
      // onRendererCreated: (CircularSeriesController controller) {
      //   _chartSeriesController?.updateDataSource(updatedDataIndexes:new List<int>.generate(chartData.length, (k) => k + 1));

      // },
      explode: true,
      dataLabelSettings: DataLabelSettings(
        textStyle: style,
        isVisible: false,
      ),
      dataSource: chartData,
      radius: '100%',
      strokeColor: Colors.white,
      strokeWidth: 0,
      xValueMapper: (UnitCount data, _) => data.unitName,
      yValueMapper: (UnitCount data, _) => data.value,

      /// The property used to apply the color for each douchnut series.
      pointColorMapper: (UnitCount data, _) => data.color,
      dataLabelMapper: (UnitCount data, _) => data.unitName,
    ),
  ];
}
