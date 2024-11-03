import 'package:app/screens/media_player_v2.dart';
import 'package:app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/galleryMedia.dart';
import 'package:app/utils/constants.dart';

class GalleryMediaTile extends StatefulWidget {
  final GalleryMedia? galleryMedia;
  const GalleryMediaTile({Key? key, this.galleryMedia}) : super(key: key);

  @override
  State<GalleryMediaTile> createState() => _GalleryMediaTileState();
}

class _GalleryMediaTileState extends State<GalleryMediaTile> {
  bool mediaViewed = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    mediaViewed = isMediaViewed(widget.galleryMedia!.id!);

    return Container(
      width: screenWidth - 20,
      height: 100.h,
      child: Stack(
        children: [
          Positioned.fill(
            top: 0,
            right: 0,
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                   // border: Border.all(color: kGreen, width: 0.w),
                    color: kCasesTileBGColor,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                          "http://161.35.46.18/gallery/${widget.galleryMedia!.id}/thumbnail.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3), BlendMode.darken),
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
                  width: 150.w,
                  height: 90.h,
                  child: Center(
                      child: Text(
                    widget.galleryMedia?.text?.toUpperCase() ?? "",
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: "FuturaBold",
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                  )),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BetterPlayerPage(
                    galleryMedia: widget.galleryMedia!, 
                  ),
                ));
              },
            ),
          ),
          mediaViewed
              ? SizedBox()
              : Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/new_badge_circle.png",
                    width: 35.w,
                  ),
                ),
        ],
      ),
    );
  }
}
