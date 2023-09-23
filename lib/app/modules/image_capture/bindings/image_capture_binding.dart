import 'package:get/get.dart';

import '../controllers/image_capture_controller.dart';

class ImageCaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageCaptureController>(
      () => ImageCaptureController(),
    );
  }
}
