import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TermDetailsViewModel extends GetxController {
  // Reactive state for language toggle
  final isEnglishFirst = true.obs;

  // TTS state
  final isSpeaking = false.obs;
  late FlutterTts _flutterTts;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  void _initTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      isSpeaking.value = true;
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });

    _flutterTts.setCancelHandler(() {
      isSpeaking.value = false;
    });

    _flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
    });
  }

  void toggleLanguage() {
    isEnglishFirst.value = !isEnglishFirst.value;
  }

  /// Speaks the given [text] using TTS.
  /// Detects language automatically: Arabic → ar-SA, English → en-US.
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    // If already speaking, stop first
    if (isSpeaking.value) {
      await _flutterTts.stop();
      isSpeaking.value = false;
      return;
    }

    // Detect language by checking for Arabic Unicode range
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    await _flutterTts.setLanguage(isArabic ? 'ar-SA' : 'en-US');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    isSpeaking.value = true;
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
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

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
