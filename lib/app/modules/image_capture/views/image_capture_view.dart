import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../main.dart';
import '../../../constants/colors.dart';
import '../controllers/image_capture_controller.dart';

// class ImageCaptureView{
//   const ImageCaptureView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return

class ImageCaptureView extends StatefulWidget {
  ImageCaptureView({super.key});

  final ImageCaptureController controller = ImageCaptureController();
  @override
  State<ImageCaptureView> createState() => _ImageCaptureViewState();
}

class _ImageCaptureViewState extends State<ImageCaptureView>
    with WidgetsBindingObserver {
  String path = '';
  CameraController? camController;
  bool _isCameraInitialized = false;
  FlashMode? _currentFlashMode;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = camController;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        camController = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = camController!.value.isInitialized;
      });
    }
    _currentFlashMode = camController!.value.flashMode;
    setState(() {
      _currentFlashMode = FlashMode.off;
    });
    await camController!.setFlashMode(
      FlashMode.off,
    );
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = camController;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);
    super.initState();
  }

  @override
  void dispose() {
    camController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = camController;

    // App state changed before we got the chance to initialize.
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
    return _isCameraInitialized
        ? SafeArea(
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
                    widget.controller.isImageTaken.value
                        ? Image.file(
                            File(path),
                            height: 20.h,
                          )
                        : const Image(
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
                                    child: ClipOval(
                                        child: AspectRatio(
                                      aspectRatio:
                                          1 / camController!.value.aspectRatio,
                                      child: camController!.buildPreview(),
                                    ))),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                XFile? rawImage = await takePicture();
                                File imageFile = File(rawImage!.path);

                                String imageId =
                                    widget.controller.idGenerator();
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                String fileFormat =
                                    imageFile.path.split('.').last;

                                await imageFile.copy(
                                  '${directory.path}/$imageId.$fileFormat',
                                );
                                print('Path ' + imageFile.path);
                                path = imageFile.path;

                                try {
                                  final ref = firebase_storage
                                      .FirebaseStorage.instance
                                      .ref('images')
                                      .child(imageId);
                                  await ref.putFile(imageFile);
                                } catch (e) {}

                                // final storageRef =
                                //     FirebaseStorage.instance.ref();
                                // try {
                                //   await storageRef.putFile(imageFile);
                                // } catch (e) {
                                //   // ...
                                //   print('exception generated $e');
                                // }
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
          )
        : const SizedBox();
  }
}
