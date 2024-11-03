import 'package:app/models/galleryMedia.dart';
import 'package:app/utils/local_auth_service.dart';
import 'package:app/utils/storage_service.dart';
import 'package:app/widgets/gallery_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final remoteServices = Get.find<RemoteServicesController>();

  @override
  void initState() {
       // remoteServices.galleryMedia = <GalleryMedia>[].obs;
    remoteServices.getGalleryItems();
    checkAuthorization();
    super.initState();
  }
  @override
  void dispose() {
    checkIfAllMediaViewed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // print("Building ${remoteServices.galleryMedia.length}");
    return Scaffold(
      //  checkIfAllMediaViewed();
      backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                  decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPath),
              fit: BoxFit.cover,
            ),
                  ),
                  child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "GALLERY",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 60.h,),
                SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
               
                Expanded(

                  //height: MediaQuery.of(context).size.height,
                  child: Obx(
                    ()=> ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: remoteServices.galleryMedia.value.length,
                      itemBuilder: (context, index) {
                        print("Building $index");
                        return GalleryMediaTile(
                            galleryMedia: remoteServices.galleryMedia[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
                  ),
                ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: MediaQuery.of(context).size.width/30,
            child:   IconButton(
          icon:Icon(Icons.arrow_back_ios),color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),),
          ],
        ));
  }
}
