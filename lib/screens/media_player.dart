// import 'package:app/models/galleryMedia.dart';
// import 'package:app/screens/gallery_screen.dart';

// import 'package:app/utils/constants.dart';
// import 'package:chewie/chewie.dart';
// import 'package:app/utils/media_player_theme.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// // ignore: depend_on_referenced_packages
// import 'package:video_player/video_player.dart';

// import '../utils/storage_service.dart';

// class MediaPlayer extends StatefulWidget {
//   const MediaPlayer({
//     Key? key,
//     required this.galleryMedia,
//   }) : super(key: key);

//   final GalleryMedia galleryMedia;

//   @override
//   State<StatefulWidget> createState() {
//     return _MediaPlayerState();
//   }
// }

// class _MediaPlayerState extends State<MediaPlayer> {
//   // TargetPlatform? _platform;
//   late VideoPlayerController _videoPlayerController;
//   late ChewieController _chewieController;
//   double _aspectRatio = 16 / 9;
//   bool _isLoading = true;
//   @override
//   void initState() {
//     initializePlayer();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);

//     addToMediaViewed(widget.galleryMedia.id!);
//     super.initState();
//   }

//   OverlayEntry? _overlayEntry;
//   @override
//   void dispose() {
//     //if (_overlayEntry != null) _overlayEntry?.remove();
//     _chewieController.dispose();
//     _videoPlayerController.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   late String src =
//       "http://161.35.46.18/gallery/${widget.galleryMedia.id}/video.mp4";
//   DragStartDetails? _dragStartDetails;
//   Future<void> initializePlayer() async {
//     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(src));
//     await Future.wait([
//       _videoPlayerController.initialize(),
//     ]);
//      _createChewieController();
//     setState(() {
//       _isLoading = false;
//     });
//     //  _chewieController.enterFullScreen();
//   }

//   Future<void> _createChewieController() async {
//     _chewieController = ChewieController(
//       // ... other Chewie options
//       customControls: CupertinoCustomControls(
//         onExitFullscreen: () {
//           _chewieController.exitFullScreen();
//         },
//       ),
//       allowedScreenSleep: false,
//       allowFullScreen: true,
//       // deviceOrientationsAfterFullScreen:
//       //  [

//       //   DeviceOrientation.portraitUp,
//       //   DeviceOrientation.portraitDown,
//       // ],
//       // //additionalOptions: (context) => <OptionItem>[
//       //   // OptionItem(
//       //   //   onTap: () {
//       //   //     Navigator.pop(context);
//       //   //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GalleryScreen()));},
//       //   //   iconData: Icons.exit_to_app,
//       //   //   title: 'Exit Player',
//       //   // ),

//       // //],
//       // deviceOrientationsOnEnterFullScreen: [
//       //   DeviceOrientation.landscapeRight,
//       //   DeviceOrientation.landscapeLeft,

//       // ],
//       showControlsOnInitialize: true,
//       showOptions: true,
//       videoPlayerController: _videoPlayerController,
//       aspectRatio: _aspectRatio,
//       autoInitialize: true,
//       autoPlay: true,
//       showControls: true,
//       fullScreenByDefault: true,
//       );
//     // _chewieController.addListener(() {
//     //   if (_chewieController.isFullScreen) {
//     //     SystemChrome.setPreferredOrientations([
//     //       DeviceOrientation.landscapeRight,
//     //       DeviceOrientation.landscapeLeft,
//     //     ]);
//     //   } else {
//     //     SystemChrome.setPreferredOrientations([
//     //       DeviceOrientation.portraitUp,
//     //       DeviceOrientation.portraitDown,
//     //     ]);
//     //   }
//     // });
//   }

//   void _showFilterSelectionDropDown() {
//     if (_overlayEntry != null) _overlayEntry?.remove();

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         right: 0,
//         left: 0,

//         // width: MediaQuery.of(context).size.width - 100,
//         child: Column(children: [
//           GestureDetector(
//             onTap: () {
//               print("exeeeeeen");
//               _chewieController.exitFullScreen();
//             },
//             onVerticalDragStart: (details) => _dragStartDetails = details,
//             onVerticalDragUpdate: (details) {
//               print((details));
//               if (_dragStartDetails != null) {
//                 final delta = details.globalPosition.dy -
//                     _dragStartDetails!.globalPosition.dy;
//                 print("sfull screen");
//                 // Handle swipe up/down based on delta (adjust threshold as needed)
//                 if (delta > 50.0) {
//                   print("exit full screen");
//                   // User swipes down to exit full screen (adjust threshold)
//                   _chewieController.exitFullScreen();
//                 }
//               }
//             },
//             onVerticalDragEnd: (_) => _dragStartDetails = null,
//             child: Container(
//                 color: Color.fromARGB(117, 212, 212, 212),
//                 width: MediaQuery.of(context).size.width - 100,
//                 height: 100),
//           )
//         ]),
//       ),
//     );
//     // print("inserting overlay entry");
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         if (_overlayEntry != null) Overlay.of(context).insert(_overlayEntry!);
//       });
//     });
//     //Overlay.of(context).insert(_overlayEntry!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _showFilterSelectionDropDown();
//     return MaterialApp(
//       title: widget.galleryMedia.text!,
//       // theme: AppTheme.light.copyWith(
//       // platform: TargetPlatform.iOS,
//       // ),
//       home: Scaffold(
//         body: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Stack(
//                 children: [
//                   Center(
//                     child: _chewieController
//                             .videoPlayerController.value.isInitialized
//                         ? Listener(
//                             onPointerHover: (details) {
//                               print("hovered");
//                             },
//                             onPointerMove: (details) {
//                               final delta =
//                                   details.delta.dx; // Horizontal swipe delta
//                               print(delta);
//                               if (delta > 1) {
//                                 print("inner $delta");
//                                 SystemChrome.setPreferredOrientations([
//                                   DeviceOrientation.portraitUp,
//                                   DeviceOrientation.portraitDown,
//                                 ]);
//                                 _videoPlayerController.dispose();
//                                 _chewieController.dispose();
//                                 Navigator.of(context).pop();
//                                 // Get.back();
//                               }
//                             },
//                             child: Chewie(controller: _chewieController!),
//                           )
//                         : const Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircularProgressIndicator(),
//                               SizedBox(height: 20),
//                               Text('Loading'),
//                             ],
//                           ),
//                   ),

//                   //           Positioned(
//                   //             top: 30.0.h, // Adjust top padding
//                   //             left: 30.w, // Adjust right padding
//                   //             child: IconButton(

//                   //               icon:      Positioned(
//                   //   top: 16.0,
//                   //   left: 16.0,
//                   //   child: IconButton(
//                   //     icon: Icon(Icons.arrow_back, color: Colors.red,),
//                   //     onPressed: _chewieController.exitFullScreen,
//                   //   ),
//                   // ),
//                   //               onPressed: () =>
//                   //                   Navigator.pop(context), // Close current screen
//                   //             ),
//                   //           ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class CupertinoCustomControls extends CupertinoControls {
//   final VoidCallback onExitFullscreen;

//   CupertinoCustomControls({
//     required this.onExitFullscreen,
//   }) : super(
//           backgroundColor: Colors.black, // Provide a default background color
//           iconColor: Colors.white, // Provide a default icon color
//         );

//   Widget build(BuildContext context) {
//     return Stack(
//       children: [],
//     );
//   }
// }
