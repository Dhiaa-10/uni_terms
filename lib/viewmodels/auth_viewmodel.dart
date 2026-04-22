import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniterm/repositories/i_auth_repository.dart';

class AuthViewModel extends GetxController {
  final IAuthRepository authRepo;
  AuthViewModel(this.authRepo);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

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

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    final success = await authRepo.signIn(email, password);
    isLoading.value = false;
    if (success) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<void> login() async {
    await signIn(emailController.text, passwordController.text);
  }
}
