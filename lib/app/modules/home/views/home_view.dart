import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:himanshu_game/app/data/colors.dart';
import 'package:himanshu_game/app/modules/image_capture/views/image_capture_view.dart';
import 'package:himanshu_game/app/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../data/snackbar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  centerTitle: true,
                  backgroundColor: kDarkBlueColor,
                ),
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      await Permission.notification.request().isGranted;
                      if (await Permission.notification.isPermanentlyDenied ||
                          await Permission.notification.isDenied) {
                        permissionDeniedSnackbar;
                      }

                      await Permission.camera.request().isGranted;
                      if (await Permission.camera.isPermanentlyDenied ||
                          await Permission.camera.isDenied) {
                        permissionDeniedSnackbar;
                      }

                      NotificationService().showNotification(
                          title: 'Sample title', body: 'It works!');

                      Get.to(ImageCaptureView(),
                          duration: const Duration(milliseconds: 500),
                          transition: Transition.rightToLeft);
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
                        style: TextStyle(fontSize: 20.sp, color: Colors.white),
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
