
import 'dart:developer';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../screens/account_statement.dart';
import '../screens/cases_screen.dart';
import '../utils/constants.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final bool inBox;

  const CustomDialogBox(
      {required this.title, required this.descriptions, required this.text, required this.inBox})
      : super();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  void initState() {
   
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
 
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: dialogPadding,
              top: dialogAvatarRadius + dialogPadding,
              right: dialogPadding,
              bottom: dialogPadding),
          margin: const EdgeInsets.only(top: dialogAvatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(dialogPadding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                       foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                       // onSurface: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(navigatorKey.currentContext!).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(fontSize: 15.sp),
                      )),
                  widget.title !="ERROR" ? TextButton(
                      onPressed: () {
                        if (widget.text == "Completed Cases") {
                          Navigator.of(context).pop();
                           pushIfNotCurrent(
                            context,CasesScreen(tabIndex: ValueNotifier<int>(1))
                          );
                          // Navigator.of(navigatorKey.currentContext!)
                          //     .push(MaterialPageRoute(
                          //   builder: (BuildContext context) =>
                          //       const CasesScreen(
                          //     tabIndex: 1,
                          //   ),
                          // ));
                        } else {
                          Navigator.of(context).pop();
                          pushIfNotCurrent(
                            context,AccountStatementScreen()
                          );
                          // Navigator.of(navigatorKey.currentContext!)
                          //     .push(MaterialPageRoute(
                          //   builder: (BuildContext context) =>
                          //       const AccountStatementScreen(),
                          // ));
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: kGreen,
                       // onSurface: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "View",
                        style: TextStyle(fontSize: 15.sp),
                      )):SizedBox()
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: dialogPadding,
          right: dialogPadding,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: dialogAvatarRadius,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(dialogAvatarRadius)),
                  child: Image.asset(widget.inBox ? "assets/images/in_box_green.png" :"assets/images/logo_white_bg.jpg")),
            ),
          ),
        ),
      ],
    );
  }
  void pushIfNotCurrent(BuildContext context, Widget page) {
    log("dialog push if not current called");
    log("isOn Screen   ${isOnScreen(context, HomeScreen())}");
  // bool isCurrent = false;
  // bool isOnCasesScreen = false;
  bool isOnHomeScreen = false;
 
 Navigator.of(context).popUntil((route) {
  // Check if the route has a name
   print("Key : ${route.settings.name}");
  if (route.settings.name == null) {
    if (route is MaterialPageRoute) {
      // Print the runtime type of the builder associated with the route
      print("Is a MaterialPageRoute: ${route.builder(context).runtimeType}");
    } else {
      isOnHomeScreen = true;
      print("Not a MaterialPageRoute");
    }
  }
  return true; // Continue popping until the condition is met
});
  log("isOnHomeScreen $isOnHomeScreen");
  
   if(!isOnHomeScreen){
      Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => page));
      }
  else
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
bool isOnScreen(BuildContext context, Widget page) {
  bool isCurrentBool = false;

  Navigator.of(context).popUntil((route) {
    if (route.settings.name == null) {
      // Check if the route is of the same type as the page you intend to push
      if (route is MaterialPageRoute &&
          route.builder(context).runtimeType == page.runtimeType) {
        isCurrentBool = true;
      }
    }
    return true;
  });

  return isCurrentBool;
}

}

