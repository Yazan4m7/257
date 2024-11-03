
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/remote_services_controller.dart';
final remoteServices = Get.find<RemoteServicesController>();
  final localStorage = GetStorage();


  void addToMediaViewed(int id){
    List mediaViewed = readListOfMediaViewed();
    if(!mediaViewed.contains(id)){
    mediaViewed.add(id);
    writeListOfMediaViewed(mediaViewed);}
  }

  bool isMediaViewed(int id){
  List mediaViewed = readListOfMediaViewed();
  if(mediaViewed.contains(id)) return true;
  return false;
  }

  writeListOfMediaViewed(List<dynamic> storageValue) async => await localStorage.write(/*key:*/ "mediaViewed", /*value:*/ storageValue);

  readListOfMediaViewed() => localStorage.read("mediaViewed") ?? [];

  void checkIfAllMediaViewed() async{
    List<int> _mediaIds = remoteServices.galleryMedia.map((media) => media.id!).toList();
    List _mediaViewedIds = readListOfMediaViewed();
    await Future.delayed(Duration.zero);
    remoteServices.isAllMediaViewed.value = true;
    _mediaIds.forEach((id) {
      if(!_mediaViewedIds.contains(id))
        remoteServices.isAllMediaViewed.value= false;
    });
  }

  void setData(String key, dynamic value) => GetStorage().write(key, value);

  int? getInt(String key) => GetStorage().read(key);

  String? getString(String key) => GetStorage().read(key);


  bool? getBool(String key) => GetStorage().read(key);

  double? getDouble(String key) => GetStorage().read(key);

  dynamic getData(String key) => GetStorage().read(key);

  void clearData() async => GetStorage().erase();
