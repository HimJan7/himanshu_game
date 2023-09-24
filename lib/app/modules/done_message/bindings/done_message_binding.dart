import 'package:get/get.dart';

import '../controllers/done_message_controller.dart';

class DoneMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoneMessageController>(
      () => DoneMessageController(),
    );
  }
}
