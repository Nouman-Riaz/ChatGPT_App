import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../circular_button_management/circular_indicator.dart';
import '../circular_button_management/circular_indicator_for_google_button.dart';
class GoogleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const GoogleButton({Key? key,required this.title,required this.loading,required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonController = Get.put(CircularIndicatorForGoogleButton());
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
