import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/api_auth_repository.dart';
import '../repositories/i_auth_repository.dart';

class AuthViewModel extends GetxController {
  final IAuthRepository authRepo;
  AuthViewModel(this.authRepo);

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading           = false.obs;
  var isPasswordVisible   = false.obs;
  var errorMessage        = ''.obs;

  // ─── Validation ────────────────────────────────────────────────────────────

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr;
    if (!GetUtils.isEmail(value)) return 'invalid_email'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;
    if (value.length < 6) return 'password_too_short'.tr;
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ─── Sign In ───────────────────────────────────────────────────────────────

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;

    // Use ApiAuthRepository extended method when available
    if (authRepo is ApiAuthRepository) {
      final (success, msg) = await (authRepo as ApiAuthRepository)
          .signInWithMessage(emailController.text.trim(), passwordController.text);
      isLoading.value = false;
      if (success) {
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = msg.isNotEmpty ? msg : 'invalid_credentials'.tr;
        Get.snackbar(
          'error'.tr,
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Fallback for mock repo
      final success = await authRepo.signIn(
          emailController.text.trim(), passwordController.text);
      isLoading.value = false;
      if (success) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('error'.tr, 'invalid_credentials'.tr,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // Keep old signIn method signature for compatibility
  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    final success = await authRepo.signIn(email, password);
    isLoading.value = false;
    if (success) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('error'.tr, 'invalid_credentials'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    // TextEditingControllers are handled by the system during transitions
    super.onClose();
  }
}
