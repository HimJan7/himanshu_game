import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:himanshu_game/app/data/snackbar.dart';
import 'package:himanshu_game/app/modules/done_message/views/done_message_view.dart';
import 'package:himanshu_game/app/modules/image_capture/controllers/image_capture_controller.dart';
import 'package:himanshu_game/app/services/notification_service.dart';
import 'package:sizer/sizer.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../../../../main.dart';
import '../../../data/colors.dart';

class ImageCaptureView extends StatefulWidget {
  ImageCaptureView({super.key});

  final ImageCaptureController controller = ImageCaptureController();
  @override
  State<ImageCaptureView> createState() => _ImageCaptureViewState();
}

class _ImageCaptureViewState extends State<ImageCaptureView>
    with WidgetsBindingObserver {
  String path = '';

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = widget.controller.camController;

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    if (mounted) {
      widget.controller.camController = cameraController;
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }
    if (mounted) {
      widget.controller.isCameraInitialized.value =
          widget.controller.camController!.value.isInitialized;
    }

    // Disable Flash
    await widget.controller.camController!.setFlashMode(
      FlashMode.off,
    );
  }

  void initUniqueIdentifierState() async {
    String identifier = '';
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      tryCatchErrorSnackBar;
    }
    if (!mounted) {
      tryCatchErrorSnackBar;
      return;
    }
    if (identifier.isNotEmpty) {
      widget.controller.deviceId = identifier;
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);

    initUniqueIdentifierState();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.camController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = widget.controller.camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Click Picture',
            style: TextStyle(fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: kDarkBlueColor,
        ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                alignment: Alignment.topCenter,
                image: AssetImage('images/Smilodon.jpeg'),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5.h),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.h),
                      topRight: Radius.circular(4.h),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Image(
                            alignment: Alignment.topCenter,
                            image: AssetImage('images/Corners.png'),
                          ),
                          const Image(
                            alignment: Alignment.topCenter,
                            image: AssetImage('images/Cutlery.png'),
                          ),
                          ClipOval(
                            child: Container(
                              height: 24.h,
                              width: 24.h,
                              decoration: BoxDecoration(
                                image: widget.controller.isImageTaken.value
                                    ? DecorationImage(
                                        image: Image.file(
                                          File(path),
                                        ).image,
                                        fit: BoxFit.fitWidth,
                                        alignment: FractionalOffset.center,
                                      )
                                    : null,
                                color: const Color(0xFF313131),
                              ),
                              child: widget.controller.isCameraInitialized
                                          .value &&
                                      widget.controller.isImageTaken.value ==
                                          false
                                  ? FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: SizedBox(
                                        height: 24.h,
                                        child: CameraPreview(
                                            widget.controller.camController!),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Click your meal',
                        style: TextStyle(fontSize: 19.sp),
                      ),
                      widget.controller.isImageTaken.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    bool result = await widget.controller
                                        .savePictureToDatabase();
                                    if (result) {
                                      Get.off(() => const DoneMessageView(),
                                          duration:
                                              const Duration(milliseconds: 500),
                                          transition: Transition.rightToLeft);
                                    } else {
                                      tryCatchErrorSnackBar;
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5.h),
                                    padding: EdgeInsets.all(1.8.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kDarkBlueColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0.5.h,
                                          spreadRadius: 0.01.h,
                                          offset: Offset(-0.1.h, 0.4.h),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 5.h,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    widget.controller.isImageTaken.value =
                                        false;
                                    NotificationService().showNotification();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5.h),
                                    padding: EdgeInsets.all(1.8.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kDarkBlueColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0.5.h,
                                          spreadRadius: 0.01.h,
                                          offset: Offset(-0.1.h, 0.4.h),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.restart_alt,
                                      color: Colors.white,
                                      size: 5.h,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () async {
                                widget.controller.image =
                                    await widget.controller.takePicture();

                                if (widget.controller.image != null) {
                                  path = widget.controller.image!.path;
                                  widget.controller.isImageTaken.value = true;
                                  print('path');
                                  print(path);

                                  Directory directory = Directory(
                                      '/data/user/0/com.example.himanshu_game/cache');
                                  List<FileSystemEntity> files =
                                      directory.listSync();

                                  print('files');
                                  print(files);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5.h),
                                padding: EdgeInsets.all(1.8.h),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kDarkBlueColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0.1.h,
                                      spreadRadius: 0.01.h,
                                      offset: Offset(0, 0.5.h),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 5.h,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
