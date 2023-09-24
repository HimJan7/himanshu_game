import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../data/colors.dart';
import '../controllers/done_message_controller.dart';

class DoneMessageView extends GetView<DoneMessageController> {
  const DoneMessageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Done',
            style: TextStyle(fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: kDarkBlueColor,
        ),
        body: Center(
          child: Text(
            'Good Job',
            style: TextStyle(
                fontSize: 40.sp,
                color: kDarkBlueColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
