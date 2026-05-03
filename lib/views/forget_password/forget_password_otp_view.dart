import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/forget_password_viewmodel.dart';

class ForgetPasswordOtpView extends StatelessWidget {
  const ForgetPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordViewModel vm = Get.find<ForgetPasswordViewModel>();

    String emailText = vm.emailController.text.trim();
    if (emailText.isEmpty) {
      emailText = 'm*****@g*****.com';
    }

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: GoogleFonts.inter(
        fontSize: 24,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFF8D64AA), width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF3A294F), width: 2),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFE7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // ─── Title ───
                Text(
                  'verify_identity'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // ─── Subtitle ───
                Text(
                  'otp_subtitle'.trParams({'email': emailText}),
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 48),

                // ─── OTP Input ───
                Center(
                  child: Pinput(
                    controller: vm.otpController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) {
                      if (!vm.isLoading.value) {
                         vm.verifyOtp();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Error Message ───
                Obx(() => vm.errorMessage.value.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            vm.errorMessage.value,
                            style: GoogleFonts.inter(
                              color: AppColors.inputBorderError,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                
                const SizedBox(height: 32),

                // ─── Continue Button ───
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryButton.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Obx(() => ElevatedButton(
                        onPressed: vm.isLoading.value ? null : vm.verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          disabledBackgroundColor: AppColors.primaryButton.withValues(alpha: 0.7),
                          foregroundColor: AppColors.primaryButtonText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          elevation: 0,
                        ),
                        child: vm.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.cardBg),
                                ),
                              )
                            : Text(
                                'continue_btn'.tr,
                                style: GoogleFonts.inter(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryButtonText,
                                ),
                              ),
                      )),
                ),

                const SizedBox(height: 32),

                // ─── Resend Code ───
                Center(
                  child: Obx(() => Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'resend_code_within'.tr,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary.withValues(alpha: 0.7),
                              ),
                            ),
                            TextSpan(
                              text: vm.resendTimerText,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
