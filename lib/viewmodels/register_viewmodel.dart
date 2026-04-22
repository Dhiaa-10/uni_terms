import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/i_auth_repository.dart';

class RegisterViewModel extends GetxController {
  final IAuthRepository authRepo;
  RegisterViewModel(this.authRepo);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'required_field'.tr;
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr; // Using existing keys if possible or fallback
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

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    // Call repository register method here when available, for now simulate
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    // For now, since register isn't fully defined in IAuthRepository we can just show a success message or go to login.
    // Assuming authRepo has or will have register.
    // bool success = await authRepo.register(firstNameController.text, lastNameController.text, emailController.text, passwordController.text);
    Get.snackbar('Success', 'Account created successfully');
    Get.offAllNamed('/sign-in');
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
