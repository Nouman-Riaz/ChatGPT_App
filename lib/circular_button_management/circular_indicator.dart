import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularIndicator extends GetxController{
  var loading = false.obs;
  void setLoading(bool value) {
    loading.value = value;
  }
}