import 'package:app/models/galleryMedia.dart';
import 'package:app/utils/ScreenOrientationManager.dart';
import 'package:app/utils/storage_service.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BetterPlayerPage extends StatefulWidget {
  final GalleryMedia galleryMedia;

  BetterPlayerPage({required this.galleryMedia});

  @override
  _BetterPlayerPageState createState() => _BetterPlayerPageState();
}

class _BetterPlayerPageState extends State<BetterPlayerPage> {
  late BetterPlayerController _betterPlayerController;
  Rx<bool> isBackBtnVisible = true.obs;
  @override
  void initState() {
        // Request landscape orientations for the video player screen
    OrientationManager.setLandscapeMode();
    super.initState();
      addToMediaViewed(widget.galleryMedia.id!);
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
          
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      //fullScreenByDefault: widget.galleryMedia.id! < 3  ? true : false,
      fullScreenByDefault: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        
        enablePlayPause: true,
        //enableFullscreen: widget.galleryMedia.id == 1 ? true : false,
        enableFullscreen:  false,
      ),
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'http://161.35.46.18/gallery/${widget.galleryMedia.id}/video.mp4',
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );

    _betterPlayerController.addEventsListener((event) {
      print('BetterPlayer Event: ${event.betterPlayerEventType}');
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        Navigator.of(context).pop();
      }
      if(BetterPlayerEventType.controlsHiddenStart == event.betterPlayerEventType){
        isBackBtnVisible.value = false;
      }
      if(BetterPlayerEventType.controlsVisible == event.betterPlayerEventType){
        isBackBtnVisible.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow popping by default
      onPopInvoked: (canPop) {
        if (canPop) {
          OrientationManager.setPortraitMode();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
          
                BetterPlayer(controller: _betterPlayerController),
                      Positioned( 
                top: 10, left : 20,
                child: Obx(
                  ()=> Visibility(
                
                    visible: isBackBtnVisible.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[600]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white,size: 20.sp,),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
 OrientationManager.setPortraitMode();
    _betterPlayerController.dispose();
    super.dispose();
  }
}
// class CustomPlayerControl extends StatelessWidget {
//   const CustomPlayerControl({required this.controller, super.key});

//   final BetterPlayerController controller;

//   void _onTap() {
//     controller.setControlsVisibility(true);
//     if (controller.isPlaying()!) {
//       controller.pause();
//     } else {
//       controller.play();
//     }
//   }

//   void _controlVisibility() {
//     controller.setControlsVisibility(true);
//     Future.delayed(const Duration(seconds: 3))
//         .then((value) => controller.setControlsVisibility(false));
//   }

//   String _formatDuration(Duration? duration) {
//     if (duration != null) {
//       String minutes = duration.inMinutes.toString().padLeft(2, '0');
//       String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//       return '$minutes:$seconds';
//     } else {
//       return '00:00';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _controlVisibility,
//       child: StreamBuilder(
//         initialData: false,
//         stream: controller.controlsVisibilityStream,
//         builder: (context, snapshot) {
//           return Stack(
//             children: [
//               Visibility(
//                 visible: snapshot.data!,
//                 child: Positioned(
//                   child: Center(
//                     child: FloatingActionButton(
//                       onPressed: _onTap,
//                       backgroundColor: Colors.black.withOpacity(0.7),
//                       child: controller.isPlaying()!
//                           ? const Icon(
//                               Icons.pause,
//                               color: Colors.white,
//                               size: 40,
//                             )
//                           : const Icon(
//                               Icons.play_arrow_rounded,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 10,
//                 right: 10,
//                 bottom: 8,
//                 child: ValueListenableBuilder(
//                   valueListenable: controller.videoPlayerController!,
//                   builder: (context, value, child) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 36,
//                               width: 100,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 shape: BoxShape.rectangle,
//                                 color: Colors.black.withOpacity(0.5),
//                               ),
//                               child: Text(
//                                 '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () async {
//                                 controller.toggleFullScreen();
//                               },
//                               icon: const Icon(
//                                 Icons.crop_free_rounded,
//                                 size: 22,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                         VideoScrubber(
//                           controller: controller,
//                           playerValue: VideoPlayerValue(duration: Duration(seconds: 10)),
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
// class VideoScrubber extends StatefulWidget {
//   const VideoScrubber(
//       {required this.playerValue, required this.controller, super.key});
//   final VideoPlayerValue playerValue;
//   final BetterPlayerController controller;

//   @override
//   VideoScrubberState createState() => VideoScrubberState();
// }

// class VideoScrubberState extends State<VideoScrubber> {
//   double _value = 0.0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant VideoScrubber oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     int position = oldWidget.playerValue.position.inSeconds;
//     int duration = oldWidget.playerValue.duration?.inSeconds ?? 0;
//     setState(() {
//       _value = position / duration;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderTheme.of(context).copyWith(
//           thumbShape: CustomThumbShape(), // Custom thumb shape
//           overlayShape: SliderComponentShape.noOverlay),
//       child: Slider(
//         value: _value,
//         inactiveColor: Colors.grey,
//         min: 0.0,
//         max: 1.0,
//         onChanged: (newValue) {
//           setState(() {
//             _value = newValue;
//           });
//           final newProgress = Duration(
//               milliseconds: (_value *
//                       widget.controller.videoPlayerController!.value.duration!
//                           .inMilliseconds)
//                   .toInt());
//           widget.controller.seekTo(newProgress);
//         },
//       ),
//     );
//   }
// }

// class CustomThumbShape extends SliderComponentShape {
//   final double thumbRadius = 6.0;

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     final canvas = context.canvas;
//     final fillPaint = Paint()
//       ..color = sliderTheme.thumbColor!
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(center, thumbRadius, fillPaint);
//   }
// }