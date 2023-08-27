import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularIndicatorForGoogleButton extends GetxController{
  var loading = false.obs;
  void setLoading(bool value) {
    loading.value = value;
  }
}