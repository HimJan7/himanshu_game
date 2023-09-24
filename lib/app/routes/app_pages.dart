import 'package:get/get.dart';

import '../modules/done_message/bindings/done_message_binding.dart';
import '../modules/done_message/views/done_message_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/image_capture/bindings/image_capture_binding.dart';
import '../modules/image_capture/views/image_capture_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_CAPTURE,
      page: () => ImageCaptureView(),
      binding: ImageCaptureBinding(),
    ),
    GetPage(
      name: _Paths.DONE_MESSAGE,
      page: () => const DoneMessageView(),
      binding: DoneMessageBinding(),
    ),
  ];
}
