import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageCaptureController extends GetxController {
  RxBool isImageTaken = false.obs;

  CameraController? camController;
  RxBool isCameraInitialized = false.obs;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String idGenerator() {
    DateTime temp = DateTime.now();
    return "${(temp.year) % 100}${temp.month.toString().padLeft(2, '0')}${temp.day.toString().padLeft(2, '0')}${temp.hour.toString().padLeft(2, '0')}${temp.minute.toString().padLeft(2, '0')}${temp.second.toString().padLeft(2, '0')}${temp.millisecond.toString().padLeft(3, '0')}${temp.microsecond.toString().padLeft(3, '0')}";
  }

  Future<File?> takePicture() async {
    final CameraController? cameraController = camController;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      File imageFile = File(file!.path);
      return imageFile;
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error occured while taking picture: $e');
      }
      return null;
    }
  }

  void savePictureToDatabase(File image) async {
    String imageId = idGenerator();
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('images')
          .child(imageId);
      await ref.putFile(image);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving image to firebase storage.');
      }
    }
  }
}
