

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himanshu_game/app/data/colors.dart';
import 'package:himanshu_game/app/modules/image_capture/views/image_capture_view.dart';
import 'package:himanshu_game/main.dart';
import 'package:sizer/sizer.dart';

import '../../../data/snackbar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Himanshu Game',
          theme: ThemeData.light(),
          home: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Home',
                    style: GoogleFonts.andika(
                        textStyle: TextStyle(fontSize: 20.sp)),
                  ),
                  centerTitle: true,
                  backgroundColor: kDarkBlueColor,
                ),
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      if (cameras.isNotEmpty) {
                        controller.getUserPermission();
                        Get.to(() => ImageCaptureView(),
                            duration: const Duration(milliseconds: 500),
                            transition: Transition.rightToLeft);
                      } else {
                        noCameraAvailable;
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: kDarkBlueColor,
                        borderRadius: BorderRadius.circular(100.w),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.5.h,
                            spreadRadius: 0.01.h,
                            offset: Offset(-0.1.h, 0.4.h),
                          ),
                        ],
                      ),
                      child: Text(
                        'Share Your Meal',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.andika(
                            textStyle: TextStyle(
                                fontSize: 20.sp, color: Colors.white)),
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}
