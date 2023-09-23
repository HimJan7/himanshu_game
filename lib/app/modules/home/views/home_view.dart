import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:himanshu_game/app/constants/colors.dart';
import 'package:himanshu_game/app/modules/image_capture/views/image_capture_view.dart';
import 'package:sizer/sizer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Home',
              style: TextStyle(fontSize: 20.sp),
            ),
            centerTitle: true,
            backgroundColor: kDarkBlueColor,
          ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => Get.to(() => ImageCaptureView()),
              child: Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: kDarkBlueColor,
                  borderRadius: BorderRadius.circular(100.w),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.1.h,
                      spreadRadius: 0.01.h,
                      offset: Offset(0, 0.5.h),
                    ),
                  ],
                ),
                child: Text(
                  'Share Your Meal',
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
              ),
            ),
          )),
    );
  }
}
