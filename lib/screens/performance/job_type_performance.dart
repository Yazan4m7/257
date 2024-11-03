import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobTypePerformance extends StatefulWidget {
  const JobTypePerformance({Key? key}) : super(key: key);

  @override
  State<JobTypePerformance> createState() => _JobTypePerformanceState();
}

late List<ChartData> chartData;
late TooltipBehavior _tooltip;
late double screenWidth;
late double screenHeight;

class _JobTypePerformanceState extends State<JobTypePerformance> {
  final reportsDataController = Get.find<ReportsDataController>();

  List reportData = [];
  Color crownColor = kGreen;
  Color veneerColor = Color.fromRGBO(251, 2, 210, 1.0);
  Color screwRetainedColor = Colors.indigo;
  Color inlayColor = Colors.amber;
  double iconSize = 25.w;

  TextStyle labelTextStyle = TextStyle(
      color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.w600);

  // TextStyle titleTextStyle = TextStyle(
  //     fontSize: 18.sp, fontWeight: FontWeight.w400, color: Colors.black);
TextStyle titleTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
  
  );
  TextStyle valueTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
  );
  @override
  void initState() {
    reportData = reportsDataController.jobTypesCounts;
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // reportData[0]["1"]=0;
    // reportData[1]["2"]=0;
    // reportData[2]["3"]=0;
    // reportData[3]["6"] =1;

    int total = reportData[0]["1"] +
        reportData[1]["2"] +
        reportData[2]["3"] +
        reportData[3]["6"];

    // prevent infinity/null dividing by 0
    total = total == 0 ? 1 : total;

    chartData = [
      ChartData('Crown', reportData[0]["1"], crownColor,
          ((reportData[0]["1"] / total) * 100).toInt()),
      ChartData('Veneer', reportData[1]["2"], veneerColor,
          ((reportData[1]["2"] / total) * 100).toInt()),
      ChartData('S.Retained', reportData[3]["6"], screwRetainedColor,
          ((reportData[3]["6"] / total) * 100).toInt()),
      ChartData('Inlay', reportData[2]["3"], inlayColor,
          ((reportData[2]["3"] / total) * 100).toInt())
    ];
    screenWidth = MediaQuery.of(context).size.width - 5.w;
    screenHeight = MediaQuery.of(context).size.height - 64.3.h;

    return Scaffold(
      backgroundColor: Colors.white,
        body: Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        boxShadow: [
          // BoxShadow(
          //   color: Colors.transparent,
          //   spreadRadius: 5,
          //   blurRadius: 7,
          //   offset: Offset(0, 3), // changes position of shadow
          // ),
        ],
        // border: Border.all(color: Colors.transparent),
        // borderRadius: BorderRadius.all(Radius.circular(0)),
         color: Colors.white,
      ),
      child: Stack(children: [
        Positioned.fill(
            top: -screenHeight / 9,
            //left: screenWidth/12,
            //width: screenWidth+10.w,
            child: _buildPieChart()),
        Column(
          children: [
            SizedBox(
              height: 35.h,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 18.0, right: 18.0),
              child: Text(
                "JOB TYPES",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            SizedBox(
              height: screenHeight / 2.5,
              width: screenWidth,
              child: Container(),
            ),
            Expanded(
              child: Container(
                  width: screenWidth - 20.w,
                  height: screenHeight / 2 - 30.h,
                  alignment: Alignment.center,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildValueContainer(chartData[0].color, chartData[0].x,
                            chartData[0].y, "assets/icons/crown.svg"),
                        _buildValueContainer(chartData[1].color, chartData[1].x,
                            chartData[1].y, "assets/icons/veneer.svg")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildValueContainer(chartData[2].color, chartData[2].x,
                            chartData[2].y, "assets/icons/screw-retained.svg"),
                        _buildValueContainer(chartData[3].color, chartData[3].x,
                            chartData[3].y, "assets/icons/inlay.svg")
                      ],
                    ),
                  ])),
            ),
          ],
        )
      ]),
    ));
  }

  SfCircularChart _buildPieChart() {
    return SfCircularChart(series: <CircularSeries>[
      DoughnutSeries<ChartData, String>(
        // Starting angle of doughnut
        startAngle: 270,
        // Ending angle of doughnut
        endAngle: 90,
        radius: "100%",

        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: labelTextStyle,
            labelPosition: ChartDataLabelPosition.inside,
            useSeriesColor: true),
        enableTooltip: true,
        dataSource: chartData,
        pointColorMapper: (ChartData data, _) => data.color,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y == 0 ? null : data.y,

        dataLabelMapper: (ChartData data, _) =>
            data.percentage == 0 ? null : data.percentage.toString() + "%",
        // Segments will explode on tap
        explode: true,
        // First segment will be exploded on initial rendering
      )
    ]);
  }

  SingleChildScrollView _buildValueContainer(
      Color color, String title, int value, String iconPath) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        width: screenWidth / 2 - 40.w,
        height: (screenHeight - 90 - screenHeight / 2) / 2 ,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.0.h,
                width: 30.0.w,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              Text(
                title,
                style: titleTextStyle,
              ),
              Text(
                value.toString(),
                style: valueTextStyle,
              ),
              //SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color, this.percentage);
  final String x;
  final int percentage;
  final int y;
  final Color color;
}
