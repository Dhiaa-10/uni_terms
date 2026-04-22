import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel vm = Get.find<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // ─── Title ───
                  Text(
                    'welcome_back'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ─── Subtitle ───
                  Text(
                    'sign_in_subtitle'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ─── Email Input ───
                  _buildEmailField(vm),
                  const SizedBox(height: 32),

                  // ─── Password Input ───
                  _buildPasswordField(vm),
                  const SizedBox(height: 16),

                  // ─── Forget Password ───
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/forget_password/email'),
                      child: Text(
                        'forget_password'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ─── Login Button ───
                  Center(child: _buildLoginButton(vm)),
                  const SizedBox(height: 16),

                  // ─── Don't have account? Create one ───
                  _buildCreateAccountRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── EMAIL FIELD ────────────────────────
  Widget _buildEmailField(AuthViewModel vm) {
    return TextFormField(
      controller: vm.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: vm.validateEmail,
      style: GoogleFonts.inter(
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'email_address'.tr,
        hintStyle: GoogleFonts.inter(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: SvgPicture.asset(
            'assets/icons/mail.svg',
            width: 24,
            height: 24,
            // Match Figma color with tokens
            colorFilter: ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
          minHeight: 24,
        ),
        // Required asterisk via suffix
        suffix: Text(
          '*',
          style: GoogleFonts.poppins(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: AppColors.asteriskColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppColors.sectionBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppColors.sectionBorder, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  // ──────────────────────── PASSWORD FIELD ────────────────────────
  Widget _buildPasswordField(AuthViewModel vm) {
    return Obx(() => TextFormField(
          controller: vm.passwordController,
          obscureText: !vm.isPasswordVisible.value,
          validator: vm.validatePassword,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'password'.tr,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: SvgPicture.asset(
                'assets/icons/lock.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 52,
              minHeight: 24,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: vm.togglePasswordVisibility,
                icon: SvgPicture.asset(
                  vm.isPasswordVisible.value ? 'assets/icons/eye_open.svg' : 'assets/icons/eye_closed.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                ),
              ),
            ),
            // Required asterisk
            suffix: Text(
              '*',
              style: GoogleFonts.poppins(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: AppColors.asteriskColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppColors.sectionBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppColors.sectionBorder, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
        ));
  }

  // ──────────────────────── LOGIN BUTTON ────────────────────────
  Widget _buildLoginButton(AuthViewModel vm) {
    return SizedBox(
      width: 343,
      height: 48,
      child: Obx(() => ElevatedButton(
            onPressed: vm.isLoading.value ? null : vm.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              disabledBackgroundColor: AppColors.primaryButton.withValues(alpha: 0.7),
              foregroundColor: AppColors.primaryButtonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
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
                    'log_in'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryButtonText,
                    ),
                  ),
          )),
    );
  }

  // ──────────────────────── CREATE ACCOUNT ROW ────────────────────────
  Widget _buildCreateAccountRow() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'dont_have_account'.tr,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Get.toNamed('/register'),
            child: Text(
              'create_one'.tr,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: AppColors.createOneColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
