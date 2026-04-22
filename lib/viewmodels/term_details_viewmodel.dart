import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TermDetailsViewModel extends GetxController {
  // Reactive state for language toggle
  final isEnglishFirst = true.obs;

  void toggleLanguage() {
    isEnglishFirst.value = !isEnglishFirst.value;
  }

  void copyToClipboard(String text, String label) {
    if (text.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      Get.snackbar(
        'Success',
        '$label copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3A294F).withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
    });
  }
}
