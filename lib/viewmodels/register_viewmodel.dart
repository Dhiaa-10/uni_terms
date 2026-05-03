import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/api_auth_repository.dart';
import '../repositories/i_auth_repository.dart';

class RegisterViewModel extends GetxController {
  final IAuthRepository authRepo;
  RegisterViewModel(this.authRepo);

  final firstNameController = TextEditingController();
  final lastNameController  = TextEditingController();
  final emailController     = TextEditingController();
  final passwordController  = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading         = false.obs;
  var isPasswordVisible = false.obs;
  var errorMessage      = ''.obs;

  // ─── Validation ────────────────────────────────────────────────────────────

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'required_field'.tr;
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr;
    if (!GetUtils.isEmail(value)) return 'invalid_email'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;
    if (value.length < 8) return 'password_too_short'.tr;
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ─── Register ──────────────────────────────────────────────────────────────

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;

    bool success = false;

    if (authRepo is ApiAuthRepository) {
      success = await (authRepo as ApiAuthRepository).registerWithNames(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } else {
      // Fallback
      final fullName =
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}';
      success = await authRepo.register(
          fullName, emailController.text.trim(), passwordController.text);
    }

    isLoading.value = false;

    if (success) {
      Get.offAllNamed('/home');
    } else {
      errorMessage.value = 'register_failed'.tr;
      Get.snackbar(
        'error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // TextEditingControllers are handled by the system during transitions
    super.onClose();
  }
}
