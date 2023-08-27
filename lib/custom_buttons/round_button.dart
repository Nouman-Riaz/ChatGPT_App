import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../circular_button_management/circular_indicator.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({Key? key,required this.title,required this.loading,required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      final buttonController = Get.put(CircularIndicator());
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13), color: Colors.orangeAccent),

          child: Center(
            child: Obx(() {
              return buttonController.loading.value
                  ? CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )
                  : Text(title);
            }),
          ),
        ));
  }
}
