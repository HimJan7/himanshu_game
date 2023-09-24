import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
            'Thank You!',
            style: GoogleFonts.andika(
                textStyle: TextStyle(fontSize: 20.sp, color: Colors.white)),
          ),
          centerTitle: true,
          backgroundColor: kDarkBlueColor,
        ),
        body: Center(
          child: Text(
            'Good Job',
            style: GoogleFonts.lilitaOne(
              textStyle: TextStyle(
                  fontSize: 50.sp,
                  color: kDarkBlueColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
