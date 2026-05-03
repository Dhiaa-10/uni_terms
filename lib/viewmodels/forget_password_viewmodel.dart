import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/api_auth_repository.dart';
import '../repositories/i_auth_repository.dart';

enum ForgetPasswordStep { email, otp, reset }

class ForgetPasswordViewModel extends GetxController {
  final IAuthRepository authRepo;
  ForgetPasswordViewModel(this.authRepo);

  // ─── State ─────────────────────────────────────────────────────────────────
  var currentStep      = ForgetPasswordStep.email.obs;
  var isLoading        = false.obs;
  var errorMessage     = ''.obs;
  var successMessage   = ''.obs;

  // Used across steps
  String _email = '';
  String _otp   = '';

  // Controllers
  final emailController       = TextEditingController();
  final otpController         = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey               = GlobalKey<FormState>();

  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  
  var resendTimerSeconds = 90.obs;
  Timer? _resendTimer;

  void startResendTimer() {
    resendTimerSeconds.value = 90;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimerSeconds.value > 0) {
        resendTimerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get resendTimerText {
    final minutes = resendTimerSeconds.value ~/ 60;
    final seconds = resendTimerSeconds.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ─── Step 1: Send OTP ──────────────────────────────────────────────────────

  Future<void> sendOtp() async {
    errorMessage.value = '';
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'invalid_email'.tr;
      return;
    }

    isLoading.value = true;
    _email = emailController.text.trim();

    final success = await authRepo.resetPassword(_email);
    isLoading.value = false;
    
    if (success) {
      startResendTimer();
      Get.toNamed('/forget_password/otp');
    } else {
      errorMessage.value = 'otp_send_failed'.tr;
    }
  }

  // ─── Step 2: Verify OTP ────────────────────────────────────────────────────

  Future<void> verifyOtp() async {
    errorMessage.value = '';
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 4) {
      errorMessage.value = 'invalid_otp'.tr;
      return;
    }

    isLoading.value = true;
    _otp = otp;

    final success = await authRepo.verifyOtp(_email, _otp);
    isLoading.value = false;
    
    if (success) {
      Get.toNamed('/forget_password/reset');
    } else {
      errorMessage.value = 'invalid_otp'.tr;
    }
  }

  // ─── Step 3: Reset Password ────────────────────────────────────────────────

  Future<void> resetPassword() async {
    errorMessage.value = '';
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    
    if (newPassword.isEmpty || newPassword.length < 8) {
      errorMessage.value = 'password_too_short'.tr;
      return;
    }
    if (newPassword != confirmPassword) {
      errorMessage.value = 'passwords_do_not_match'.tr;
      return;
    }

    isLoading.value = true;

    final success = await authRepo.resetPasswordWithOtp(_email, _otp, newPassword);
    isLoading.value = false;
    
    if (success) {
      Get.offAllNamed('/sign_in');
      Get.snackbar('success'.tr, 'password_reset_success'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      errorMessage.value = 'reset_failed'.tr;
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    // TextEditingControllers are better left to be GC'd or handled by the system 
    // when using GetX transitions to avoid 'used after disposed' errors 
    // during fast route popping.
    super.onClose();
  }
}
