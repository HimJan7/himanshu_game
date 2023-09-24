import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:himanshu_game/app/data/colors.dart';
import 'package:sizer/sizer.dart';

SnackbarController tryCatchErrorSnackBar = Get.snackbar(
  'Alert !',
  'An error has occured.',
  snackPosition: SnackPosition.BOTTOM,
  colorText: Colors.white,
  backgroundColor: kDarkBlueColor,
  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
  margin: EdgeInsets.symmetric(
    horizontal: 3.w,
    vertical: 1.5.h,
  ),
  icon: Icon(
    Icons.error,
    size: 4.h,
    color: Colors.white,
  ),
);

SnackbarController permissionDeniedSnackbar = Get.snackbar(
  'Alert !',
  'Permission Denied.',
  snackPosition: SnackPosition.BOTTOM,
  colorText: Colors.white,
  backgroundColor: kDarkBlueColor,
  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
  margin: EdgeInsets.symmetric(
    horizontal: 3.w,
    vertical: 1.5.h,
  ),
  icon: Icon(
    Icons.error,
    size: 4.h,
    color: Colors.white,
  ),
);
