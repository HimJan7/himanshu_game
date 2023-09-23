import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ImageCaptureController extends GetxController {
  RxBool isImageTaken = false.obs;
  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String idGenerator() {
  DateTime temp = DateTime.now();
  return "${(temp.year) % 100}${temp.month.toString().padLeft(2, '0')}${temp.day.toString().padLeft(2, '0')}${temp.hour.toString().padLeft(2, '0')}${temp.minute.toString().padLeft(2, '0')}${temp.second.toString().padLeft(2, '0')}${temp.millisecond.toString().padLeft(3, '0')}${temp.microsecond.toString().padLeft(3, '0')}";
}
}
