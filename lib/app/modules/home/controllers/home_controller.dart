import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/snackbar.dart';

class HomeController extends GetxController {

  void getUserPermission() async {
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
  }
}
