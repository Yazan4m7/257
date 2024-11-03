import 'dart:convert';
import 'dart:developer';

import 'package:app/controllers/remote_services_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/encrypt.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'auth_controller.dart';

class ReportsDataController extends GetxController{
  static ReportsDataController get instance => Get.find();
  final authController = Get.find<AuthController>();
  final remoteServiceController =Get.find<RemoteServicesController>();

  RxList unitsCounts = [].obs;
  RxList jobTypesCounts = [].obs;
  RxList QCCounts = [].obs;
  RxList implantsCounts = [].obs;
  Rx<Jiffy> date = Jiffy.now().obs;
  @override
  void onReady() {
    super.onReady();
    authController.isDoctorAccount.listen((event) {
      log("IS DOCTOR ACCOUNT: $event");
      if(event == true)
        fetchReportsData();
    });

  }

  Future<void> fetchReportsData()async{
    log("FETCHING REPORTS DATA");
  // Run all the asynchronous functions concurrently and wait for all of them to complete
  await Future.wait([
    getUnitCountsReportData(),
    getJobTypesReportData(),
    getQCReportData(),
    getImplantsReportData(),
  ]);

  }
  clearPerformanceData(){
    unitsCounts.clear();
    jobTypesCounts.clear();
    QCCounts.clear();
    implantsCounts.clear();
  }
  Future<void> getUnitCountsReportData() async {
      log("fetching unit counts, current array : ${unitsCounts.toJson()}");
    var response = await http.post(Uri.parse(getUnitCountsReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
        
        log("fetching unit counts  data: ${response.body} for ${authController.client.value.phone}");
        log(encrypt(authController.client.value.phone!));
    var jsons = jsonDecode(response.body);
    unitsCounts = [].obs;
    unitsCounts.value=jsons;

  }
  Future<void> getJobTypesReportData() async {

    var response = await http.post(Uri.parse(getJobTypesReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    jobTypesCounts.value=jsons;

  }
  Future<void> getQCReportData() async{
    var response = await http.post(Uri.parse(getQCReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    QCCounts.value=jsons;
  }

  Future<void> getImplantsReportData() async{
    var response = await http.post(Uri.parse(getImplantsReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    implantsCounts.value=jsons;
  }
}