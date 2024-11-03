import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RemoteMessage? _remoteMessage;

  RemoteMessage? get remoteMessage => _remoteMessage;

  set remoteMessage(RemoteMessage? remoteMessage) {
    _remoteMessage = remoteMessage;
   
  }
}
