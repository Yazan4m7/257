import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:app/controllers/remote_services_controller.dart';

class MainBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<RemoteServicesController>(RemoteServicesController());
    Get.put<ReportsDataController>(ReportsDataController());
    
  }

}