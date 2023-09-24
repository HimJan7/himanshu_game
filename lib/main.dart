import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:himanshu_game/app/data/snackbar.dart';
import 'package:himanshu_game/app/modules/home/views/home_view.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/services/notification_service.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      print('Error in fetching the cameras: $e');
    }
  }



  await Firebase.initializeApp();
  NotificationService().initNotification();

  runApp(const HomeView());
}
