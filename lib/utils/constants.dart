import 'package:flutter/material.dart';


const double dialogPadding =20;
const double dialogAvatarRadius =35;

String backgroundPath = "assets/images/background3.jpg";
Color kBlack = const Color (0xFF393939);
Color kWhite = const Color (0xFFF3F3F3);
Color kGreen = const Color (0xFF39b34a);
Color kBlue = const Color (0xff0b4aa9);
Color kGreenDark = const Color (0xff119121);
Color kBlueDark = const Color (0xff0f0e36);
Color kGrey = const Color(0xff5d5d5d);
Color kAccountStatementForegroundColor= const Color(0xfffff9f9);
Color kCasesForegroundColor= const Color(0xfffff9f9);
Color kAccountStatementTileBGColor = const Color(0x3de5e5e5);
Color kCasesTileBGColor = const Color(0x3de5e5e5);
double main_btns_text_size = 17;


String fontFamily = 'Quest';

final navigatorKey = GlobalKey<NavigatorState>();

//String ipAddress = "http://10.0.2.2:80";
String ipAddress = "http://161.35.46.18:80";

String loginAddress = "$ipAddress/api/login";
String clientInfoAddress = "$ipAddress/api/client-info";
String openingBalanceAddress = "$ipAddress/api/opening-balance";
String accountStatementAddress = "$ipAddress/api/statement";
String getJobsAddress = "$ipAddress/api/get-jobs";
String getInProgressCasesAddress = "$ipAddress/api/get-in-progress-cases";
String getCompletedCasesAddress = "$ipAddress/api/get-completed-cases";
String getCurrentBalanceAddress= "$ipAddress/api/get-current-balance";
String getEmployeesAddress = "$ipAddress/api/get-employees";
String checkIfPhoneExistsAddress = "$ipAddress/api/check-if-phone-exists";
String getGalleryMediaAddress = "$ipAddress/api/get-gallery-items";
String setNotificationTokenAddress = "$ipAddress/api/set-notification-token";
String removeTokenAddress = "$ipAddress/api/remove-token";
String registerLoginAddress = "$ipAddress/api/register-login-time";
// Reports Addresses
String getUnitCountsReportAddress = "$ipAddress/api/num-of-units-report";
String getJobTypesReportAddress = "$ipAddress/api/job-types-report";
String getQCReportAddress = "$ipAddress/api/QC-report";
String getImplantsReportAddress = "$ipAddress/api/implants-report";
