
import 'dart:developer';

import 'package:app/utils/storage_service.dart';
import 'package:app/widgets/custom_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../controllers/auth_controller.dart';
import '../controllers/remote_services_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, bool? autoFillWithBioAuth})
      : shoulAutoFillWithBioAuth = autoFillWithBioAuth ?? true,
        super(key: key);

  final bool shoulAutoFillWithBioAuth;


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());
  final remoteServices = Get.put(RemoteServicesController());
  TextEditingController phoneNumberFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  bool _keyboardVisible = false;
  ScrollController _scrollController = ScrollController();
  var focusNode = FocusNode();
  var keyboardVisibilityController = KeyboardVisibilityController();
  double textFieldHeight = 50.h;
  var textFieldWidth;
  @override
  void initState() {
    // if (kDebugMode) {
    //   AuthController.instance.login(
    //             "+962788160099",
    //             "123456");
    //   }
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted)
        setState(() {
          _keyboardVisible = visible;
          if (visible)
            _scrollToTop();
          else
            _scrollToBottom();
        });
    });
    autoFillIfLoggedIn();
    super.initState();
    //throw Exception();
  }

  _scrollToTop() async {
    await Future.delayed(Duration(milliseconds: 150));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  autoFillIfLoggedIn() async {
    bool isLoggedIn = getData("isLoggedIn") ?? false;
  if (getData("phoneNum") != null) 
   await authController.getClient();


    if (isLoggedIn && widget.shoulAutoFillWithBioAuth) {
       log("--------- calling auth from auto fill esumed --------");
      if (await authController.AuthinticateWithBiometric() ) {
        setState(() {
          String phoneNum = getData("phoneNum");
          phoneNumberFieldController.text =
              phoneNum.substring(phoneNum.length - 9);
          passwordFieldController.text = getData("password");
        });

        _logIn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.loaderOverlay.show();
    textFieldWidth = MediaQuery.of(context).size.width / 1.3;
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage('assets/images/AI/ (2).png'),
            //      fit: BoxFit.fill,
            //      opacity: 0.1),
            ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: 130.h),
              _buildLogo(),
              SizedBox(height: 25.h),
              _greetingText(),
              SizedBox(
                height: 45.h,
              ),
              _phoneTextField(),
              SizedBox(
                height: 45.h,
              ),
              _passwordTextField(),
              SizedBox(
                height: 45.h,
              ),
              _loginBtn(),
              _keyboardVisible
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
    );
  }

  Widget _greetingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 25.h),
        Text(
          "Hello",
          style: GoogleFonts.raleway(fontSize: 35.sp, color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
          child: Text(
            textAlign: TextAlign.center,
            "Please enter your phone number and password",
            style: GoogleFonts.raleway(fontSize: 15.sp, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _phoneTextField() {
    return Container(
      width: textFieldWidth,
      height: textFieldHeight,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(35.0),
        border: Border.all(color: kGreen, width: 2.sp),
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, 5),
        //     blurRadius: 10.0,
        //     color: Colors.black.withOpacity(0.5),
        //   ),
        // ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          style: TextStyle(fontSize: 17.sp, color: Colors.white),
          controller: phoneNumberFieldController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            
            fillColor: Colors.transparent,
            focusColor: Colors.transparent,
             contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            prefixIcon: Container(
              width: MediaQuery.of(context).size.width / 6,
              child: Center(
                child: Text(
                  '+962',
                  style: TextStyle(fontSize: 17.sp, color: Colors.white),
                ),
              ),
            ),
            hintText: "78 xxx xxxx",
            
            hintStyle: TextStyle(
                fontSize: 17.sp, color: Colors.white.withOpacity(0.7)),
            // border: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.transparent, width: 32.0),
            //   // borderRadius: BorderRadius.circular(23.0),
            // ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              // borderRadius: BorderRadius.circular(23.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              // borderRadius: BorderRadius.circular(23.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      width: textFieldWidth,
      height: textFieldHeight,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(35.0),
        border: Border.all(color: kGreen, width: 3.sp),
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, 5),
        //     blurRadius: 10.0,
        //     color: Colors.black.withOpacity(0.5),
        //   ),
        // ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          obscureText: true,
          style: TextStyle(fontSize: 17.sp, color: Colors.white),
          controller: passwordFieldController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            focusColor: Colors.transparent,
            // contentPadding: EdgeInsets.fromLTRB(50.0, 90.0, 20.0, 15.0),
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Icon(
                  Icons.key_outlined,
                  color: Colors.white,
                )),
            hintText: "*********",
            hintStyle: TextStyle(
                fontSize: 16.sp, color: Colors.white.withOpacity(0.7)),
            // border: OutlineInputBorde
            //   borderSide: BorderSide(color: Colors.transparent, width: 32.0),
            //   // borderRadius: BorderRadius.circular(23.0),
            // ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              // borderRadius: BorderRadius.circular(23.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              // borderRadius: BorderRadius.circular(23.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return TextButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(Size(textFieldWidth, 45.h)),
        backgroundColor: WidgetStateProperty.all<Color>(kGreen),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
            side: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      onPressed: () async {
        _logIn();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.h),
        child: Text(
          //overflow: TextOverflow.fade,
          "LOGIN",
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
    );
  }

  bool validateMobile(String value) {
    if (value.substring(0, 1) == "0") value = value.substring(1, value.length);
    if (value.substring(0, 2) != "78" &&
        value.substring(0, 2) != "79" &&
        value.substring(0, 2) != "79") {
      return false;
    }
    if (value.length != 9) {
      print("${value} length less than 9");
      return false;
    }
    return true;
  }

  phoneExistsInSystem(String value) async {
    var response = await http
        .post(Uri.parse(checkIfPhoneExistsAddress), body: {'phoneNum': value});
    return response.body == "1" ? true : false;
  }
_logIn() async {
    
    //context.loaderOverlay.show();
    if (validateMobile(phoneNumberFieldController.text.trim())) {
      bool response = true;
      log("auth controller phone number is ${phoneNumberFieldController.text.trim()}");
      response = await AuthController.instance.login(
          "+962${phoneNumberFieldController.text.trim()
          }",
          passwordFieldController.text.trim(),
          );

      if (!response)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "ERROR",
              descriptions: authController.errorMsg.value,
              text: "",
              inBox: false,
            );
          },
        );
        print("_logIn() success");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "ERROR",
            descriptions: "Invalid phone number format",
            text: "",
            inBox: false,
          );
        },
      );
    }
  }
}
