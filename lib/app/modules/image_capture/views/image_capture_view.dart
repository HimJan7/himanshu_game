import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../main.dart';
import '../../../constants/colors.dart';
import '../controllers/image_capture_controller.dart';

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

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);
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
                  padding: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.topCenter,
                  //  width: 100.w,
                  //  height: 62.h,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.h),
                      topRight: Radius.circular(4.h),
                    ),
                  ),
                  child: Column(
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
                          Container(
                            height: 25.h,
                            width: 25.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF313131),
                            ),
                            child: !widget.controller.isCameraInitialized.value
                                ? null
                                : widget.controller.isImageTaken.value
                                    ? Image.file(
                                        File(path),
                                        height: 20.h,
                                      )
                                    : ClipOval(
                                        child: AspectRatio(
                                          aspectRatio: 1 /
                                              widget.controller.camController!
                                                  .value.aspectRatio,
                                          child: widget
                                              .controller.camController!
                                              .buildPreview(),
                                        ),
                                      ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          File? image = await widget.controller.takePicture();

                          if (image != null) {
                            path = image.path;
                            widget.controller.isImageTaken.value = true;
                            widget.controller.savePictureToDatabase(image);
                          }

                          widget.controller.isImageTaken.value = true;
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 6.h),
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
