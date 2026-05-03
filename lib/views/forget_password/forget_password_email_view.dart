import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/forget_password_viewmodel.dart';

class ForgetPasswordEmailView extends StatelessWidget {
  const ForgetPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordViewModel vm = Get.find<ForgetPasswordViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFE7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: vm.formKey, // Ensure we validate the email field
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
                    'enter_email_subtitle'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ─── Email Input ───
                  _buildEmailField(vm),
                  const SizedBox(height: 16),

                  // ─── Error Message ───
                  Obx(() => vm.errorMessage.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            vm.errorMessage.value,
                            style: GoogleFonts.inter(
                              color: AppColors.inputBorderError,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                  const SizedBox(height: 32),

                  // ─── Continue Button ───
                  _buildContinueButton(vm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── EMAIL FIELD ────────────────────────
  Widget _buildEmailField(ForgetPasswordViewModel vm) {
    return TextFormField(
      controller: vm.emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: null,
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'email_address'.tr),
              TextSpan(
                text: ' *',
                style: GoogleFonts.inter(
                  color: const Color(0xFFC67C7C), // Muted red for asterisk
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: SvgPicture.asset(
            'assets/icons/mail.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.7), BlendMode.srcIn),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Color(0xFF8D64AA), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Color(0xFF3A294F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 2),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  // ──────────────────────── CONTINUE BUTTON ────────────────────────
  Widget _buildContinueButton(ForgetPasswordViewModel vm) {
    return Container(
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
            onPressed: vm.isLoading.value ? null : vm.sendOtp,
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
    );
  }
}
